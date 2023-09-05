class DishesController < ApplicationController
  before_action :set_dish, only: [:show]

  def index
    @menu = Menu.find(params[:menu_id])
    @dishes = Dish.includes(:dish_photos).where(menu: @menu)

   # scrape_image(dish) <-- have this fetched for each dish in @menu in a js.
  end

  def text_extract
    @menu = Menu.new(menu_params)
    @menu.user = current_user
    @menu.save

    require 'json'
    # Step 1 - Set path to the image file, API key, and API URL.
    image_file = @menu.photo.url
    Rails.logger.debug "url: #{image_file}"

    # API_KEY = 'XXXXXXXXXX' # Don't forget to protect your API key.
    api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV["GOOGLE_API_KEY"]}"
    # Step 2 - Set request JSON body.
    body = "{
      'requests': [
        {
          'features': [
            {
              'maxResults': 50,
              'type': 'LANDMARK_DETECTION'
            },
            {
              'maxResults': 50,
              'type': 'FACE_DETECTION'
            },
            {
              'maxResults': 50,
              'type': 'OBJECT_LOCALIZATION'
            },
            {
              'maxResults': 50,
              'type': 'LOGO_DETECTION'
            },
            {
              'maxResults': 50,
              'type': 'LABEL_DETECTION'
            },
            {
              'maxResults': 50,
              'model': 'builtin/latest',
              'type': 'DOCUMENT_TEXT_DETECTION'
            },
            {
              'maxResults': 50,
              'type': 'SAFE_SEARCH_DETECTION'
            },
            {
              'maxResults': 50,
              'type': 'IMAGE_PROPERTIES'
            },
            {
              'maxResults': 50,
              'type': 'CROP_HINTS'
            }
          ],
          'image': {
            'source': {
              'imageUri': '#{image_file}'
            }
          },
          'imageContext': {
            'cropHintsParams': {
              'aspectRatios': [
                0.8,
                1,
                1.2
              ]
            }
          }
        }
      ]
    }"
    # Step 4 - Send request using Faraday
    connection = Faraday.new(
      url: api_url,
      headers: { 'Content-Type' => 'application/json' }
    )
    response = connection.post('', body, "Content-Type" => "application/json")

    # Step 5 - Parse the response into a usable format
    Rails.logger.debug response.body
    data_hash = JSON.parse(response.body)["responses"][0]

    # Menus typically have capitalised or uppercase menu items (followed by lower case descriptions)
    # and so the following code will take the entire block and *hopefully* return the
    # meal title.

    # Step 6 - filter the response to get out the useful stuff
    filtered_json_response = data_hash["fullTextAnnotation"]["pages"][0]["blocks"].map { |b| b["paragraphs"].map { |p| p["words"].map { |w| w["symbols"].map { |s| s["text"] }.join}} }.join

    if filtered_json_response.scan(/[A-Z]/).size < 500
      text = filtered_json_response.split(".")
      meals = text.map do |t|

        text_split = t.split(/[A-Z]/) # separates into words using capitalised letters as word split point, until next end.
        text_scan = t.scan(/[A-Z]/)
        i = 0
        string = ""
        text_scan.count.times do
          string += text_scan[i]
          string += text_split[i + 1]
          string += " "
          i += 1
        end

        pattern = / ?[A-Z].+/
        string.split("\n").size > 1 ? last_string = string.split("\n") : last_string = string.split # checks if blocks are separated by new lines or by spaces
        meal_name = last_string.map do |current_index|
          current_index if pattern.match?(current_index) && current_index.split[0].size < 15 && current_index.split[0].size > 1 # map the current item if conditions are matched (i.e. its a menu item)
        end
        meal_name.join # returns the single joined meal name to be mapped into meals
      end
      tidy_up(meals)
    else
      meals = filtered_json_response.split(/[^A-Z]/)
      meals.map!(&:downcase)
      tidy_up(meals)
      meals.uniq!
    end
    meals.each do |m|
      dish = Dish.create!(title: m, menu: @menu) # this line creates a new dish for each of the found meal titles
    end
    redirect_to menu_dishes_path(@menu)
  end

  def image_search
    dish = Dish.find(params["dish_id"])
    scrape_image(dish)
    render json: { dish: Dish.find(params["dish_id"]), photo: Dish.find(params["dish_id"]).dish_photos }
  end

  def show
  end

  private

  def check_url(url)
    url && url.starts_with?('http') && (url.end_with?('.png') || url.end_with?('.jpg') || url.end_with?('.jpeg') || url.end_with?('.webp'))
  end

  def scrape_image(dish)
    result = GoogleCustomSearchApi.search(dish.title)
    result.items.each do |photo|
      if (photo.key? "pagemap") && (photo.pagemap.key? "metatags")
        DishPhoto.create(dish: dish, url: photo.pagemap.metatags.first["og:image"]) if check_url(photo.pagemap.metatags.first["og:image"])
      elsif (photo.key? "pagemap") && (photo.pagemap.key? "cse_image")
        DishPhoto.create(dish: dish, url: photo.pagemap.cse_image[0].src) if check_url(photo.pagemap.cse_image[0].src)
      end
    end
  end

  def set_dish
    @dish = Dish.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:restaurant_name, :photo)
  end

  def tidy_up(meals)
    meals.reject! { |m| m == "" } # removes blank array elements
    meals.reject! { |m| m.size < 3 }
    meals.reject! { |m| m.size > 30 }
    meals.reject! { |m| %r[[\?\/\*]].match?(m) }
    meals.uniq!
  end
end
