# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "Creating all model data"
christian = User.create!(email: "cjmorris@yahoo.com", password: "123456")
# mark = User.create!(email: "mark@yahoo.com", password: "123456")
# will = User.create!(email: "will@yahoo.com", password: "123456")


def create_dish_with_ingredients(title, ingredients, menu)
  dish = Dish.create!(title: title, description: ingredients.join(", "), menu: menu)
  ingredients.each do |ingredient|
    Ingredient.create!(name: ingredient, dish: dish)
  end
end

menu = Menu.create!(restaurant_name: "Luigi's", user: christian)
create_dish_with_ingredients("cheeseburger", %w[beef cheese onions ketchup], menu)
create_dish_with_ingredients("sushi", %w[rice fish tofu], menu)
create_dish_with_ingredients("toadinhole", %w[sausage, pudding, onion, vegetables], menu)

puts "Users created: #{User.count}"
puts "Menus created: #{Menu.count}"
puts "Dishes create: #{Dish.count}"
puts "Ingredients create: #{Ingredient.count}"
