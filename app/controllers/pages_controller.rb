class PagesController < ApplicationController
  # before_action :set_menu
  def new
    @menu = Menu.new
  end

  def set_menu
    # @menu = Menu.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:restaurant_name)
  end

  # Vision AI returns a string in each block where every character is separated by space.
  # Menus typically have capitalised menu items (followed by lower case descriptions)
  # and so the following code will take the entire block and *hopefully* return the
  # meal title.

  text = filtered_json_response.split(".")
  meals = text.map { |t|

    text_split = t.split(/[A-Z]/)
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
    string.split("\n").size > 1 ? last_string = string.split("\n") : last_string = string.split
    meal_name = last_string.map do |current_index|
      current_index if pattern.match?(current_index) && current_index.split[0].size < 15 && current_index.split[0].size > 1
    end
    meal_name = meal_name.join
  }
  meals.reject! { |m| m == "" }

  # cloud vision api json search query to extract text
  filtered_json_response = data_hash["fullTextAnnotation"]["pages"][0]["blocks"].map { |b| b["paragraphs"].map { |p| p["words"].map { |w| w["symbols"].map { |s| s["text"] }.join}} }.join

end
