class PagesController < ApplicationController
  def home
  end

  # Vision AI returns a string in each block where every character is separated by space.
  # Menus typically have capitalised menu items (followed by lower case descriptions)
  # and so the following code will take the entire block and *hopefully* return the
  # meal title.

  text = "P u l l e d P o r k L o a d e d C h i p s
  B a t t e r e d c h i p s t o p p e d w i t h p u l l e d p o r k , s w e e t o n i o n b b q s a u c e & m e l t e d c h e e s e g a r n i s h e d w i t h c r i s p y c o l e s l a w ."
  text = text.gsub(" ", "")
  text_split = text.split(/[A-Z]/)
  text_scan = text.scan(/[A-Z]/)
  i = 0
  text_scan.count.times do
    string += text_scan[i]
    string += text_split[i + 1]
    string += " "
    i += 1
  end

  pattern = / ?[A-Z].+/
  string.split("\n").size > 1 ? last_string = string.split("\n") : last_string = string.split
  meal_name = last_string.map do |current_index|
    current_index if pattern.match?(current_index) && current_index.split[0].size < 15
  end
  meal_name = meal_name.join

  # cloud vision api json search query to extract text
  data_hash["fullTextAnnotation"]["pages"][0]["blocks"].map { |b| b["paragraphs"].map { |p| p["words"].map { |w| w["symbols"].map { |s| s["text"] }.join}} }

end
