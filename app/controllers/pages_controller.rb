class PagesController < ApplicationController
  def home

      # Menus typically have capitalised or uppercase menu items (followed by lower case descriptions)
      # and so the following code will take the entire block and *hopefully* return the
      # meal title.
    file = File.open("./test/sample_data/test_five.json")
    data_hash = JSON.load file
    # cloud vision api json search query to extract text
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
    @meals
  end

  def tidy_up(meals)
    meals.reject! { |m| m == "" } # removes blank array elements
    meals.reject! { |m| m.size < 3 }
    meals.reject! { |m| m.size > 30 }
    meals.reject! { |m| %r[[\?\/\*]].match?(m) }
    meals.uniq!
  end

end
