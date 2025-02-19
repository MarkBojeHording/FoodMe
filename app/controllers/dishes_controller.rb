class DishesController < ApplicationController
  before_action :set_dish, only: [:show]

  def index
    @menu = Menu.find(params[:menu_id])
    @dishes = Dish.includes(:dish_photos).where(menu: @menu)
  end

  def translate
  end

  def text_extract
    NotificationChannel.broadcast_to(User.first, { message: "Uploading menu 📥" })

    @menu = Menu.new(menu_params)
    @menu.user = User.first

    Rails.logger.debug "🔍 Trying to save @menu..."
    if @menu.save
      Rails.logger.debug "✅ Menu saved successfully! ID: #{@menu.id}"
    else
      Rails.logger.debug "❌ Menu save failed: #{@menu.errors.full_messages.join(", ")}"
      flash[:alert] = "Menu save failed!"
      return redirect_to root_path
    end

    NotificationChannel.broadcast_to(User.first, { message: "Analysing menu 🤓", burgerShow: true })

    require 'json'
    require "base64"
    require "open-uri"

    if @menu.photo.attached?
      begin
        image_file_url = url_for(@menu.photo)
        image_data = URI.open(image_file_url).read
        base64_image = Base64.strict_encode64(image_data)
        Rails.logger.debug "📸 Image successfully converted to Base64!"
      rescue => e
        Rails.logger.error "❌ Failed to download and convert image: #{e.message}"
        flash[:alert] = "Failed to process image for OCR."
        return redirect_to root_path
      end
    else
      Rails.logger.debug "❌ No photo found for OCR!"
      flash[:alert] = "No photo available for text extraction!"
      return redirect_to root_path
    end

    api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV["GOOGLE_API_KEY"]}"

    body = {
      requests: [{
        features: [{ maxResults: 50, type: 'DOCUMENT_TEXT_DETECTION' }],
        image: { content: base64_image }
      }]
    }.to_json

    connection = Faraday.new(url: api_url, headers: { 'Content-Type' => 'application/json' })
    response = connection.post('', body, "Content-Type" => "application/json")

    Rails.logger.debug "📜 OCR Response: #{response.body}"

    data_hash = JSON.parse(response.body)["responses"][0]
    filtered_text = data_hash.dig("fullTextAnnotation", "text") || ""

    if filtered_text.blank?
      Rails.logger.debug "❌ No text extracted from image!"
      flash[:alert] = "Text extraction failed!"
      return redirect_to root_path
    end

    meals_and_descriptions = open_ai(filtered_text)

    meals = meals_and_descriptions[1].map { |r| r["meal"] }
    descriptions = meals_and_descriptions[1].map { |r| r["description"] }

    meals.each_with_index do |m, i|
      next if m.nil? || m.strip.empty?

      Rails.logger.debug "🔄 Attempting to create dish: #{m}"

      dish = Dish.new(title: m, t_title: m, description: descriptions[i], menu: @menu)

      if dish.save
        Rails.logger.debug "✅ Dish created! ID: #{dish.id}, Title: #{dish.title}"
      else
        Rails.logger.debug "❌ Dish save failed: #{dish.errors.full_messages.join(", ")}"
      end
    end

    NotificationChannel.broadcast_to(User.first, { message: "Dishes found! 🤤" })

    # ✅ Final Debugging Before Redirect
    if @menu.nil?
      Rails.logger.debug "🚨 ERROR: @menu is NIL before redirecting!"
      flash[:alert] = "Something went wrong: Menu not found!"
      return redirect_to root_path
    end

    Rails.logger.debug "🔍 Redirecting to /menus/#{@menu.id} (menu_path: #{menu_path(@menu) rescue 'ERROR'})"

    respond_to do |format|
      format.html { redirect_to menu_path(@menu) } # Redirect to the menu's show page
      format.turbo_stream { render turbo_stream: turbo_stream.replace("body", partial: "shared/redirect", locals: { url: menu_path(@menu) }) }
    end
  end

  def image_search
    dish = Dish.find(params["dish_id"])
    scrape_image(dish) if dish.dish_photos.count.zero?
    render json: { dish: dish, photo: dish.dish_photos }
  end

  def show
    Rails.logger.debug "✅ Dish found: #{@dish.title} (ID: #{@dish.id})"

    respond_to do |format|
      format.html
      format.json { render json: @dish }
    end
  end

  private

  def set_dish
    Rails.logger.debug "🔍 Checking PARAMS[:id]: #{params[:id]}"
    @dish = Dish.find_by(id: params[:id])

    if @dish.nil?
      Rails.logger.debug "❌ Dish not found! Redirecting..."
      flash[:alert] = "Dish not found!"
      redirect_to root_path and return
    end

    Rails.logger.debug "✅ Dish found: #{@dish.title} (ID: #{@dish.id})"
  end

  def menu_params
    params.require(:menu).permit(:restaurant_name, :photo)
  end

  def open_ai(text)
    require 'openai_chatgpt'
    client = OpenaiChatgpt::Client.new(api_key: ENV["OPENAI_API_KEY"])
    resp = client.completions(
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: "Extract meals and descriptions as JSON: #{text}" }]
    )

    result = resp.results.first.content
    Rails.logger.debug "🔍 OpenAI Response: #{result}"

    begin
      ["json", JSON.parse(result)]
    rescue JSON::ParserError
      Rails.logger.debug "❌ JSON Parsing failed!"
      ["error", []]
    end
  end

  def scrape_image(dish)
    result = GoogleCustomSearchApi.search(dish.title)
    result.items.each do |photo|
      if photo.dig("pagemap", "metatags", 0, "og:image")&.match?(/\.(png|jpg|jpeg|webp)$/)
        DishPhoto.create(dish: dish, url: photo["pagemap"]["metatags"][0]["og:image"])
      elsif photo.dig("pagemap", "cse_image", 0, "src")&.match?(/\.(png|jpg|jpeg|webp)$/)
        DishPhoto.create(dish: dish, url: photo["pagemap"]["cse_image"][0]["src"])
      end
    end
  end
end
