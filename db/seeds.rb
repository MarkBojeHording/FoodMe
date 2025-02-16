# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require "open-uri"

puts "Deleting all previous tables..."
Ingredient.destroy_all
Dish.destroy_all
Menu.destroy_all
User.destroy_all
puts "successfully deleted!"

puts "Creating all model data"
christian = User.create!(email: "cjmorris@yahoo.com", password: "123456")
mark = User.create!(email: "mark@yahoo.com", password: "123456")
will = User.create!(email: "will@yahoo.com", password: "123456")

def create_dish_with_ingredients(title, ingredients, menu)
  dish = Dish.new(title: title, description: ingredients.join(", "), menu: menu)

  file1 = URI.open("https://media.istockphoto.com/id/1314976610/id/foto/kodok-di-dalam-lubang.jpg?s=612x612&w=0&k=20&c=V8ZAtH_27aFXG3fNeyOuCvbdiKVFTJdp1NW1xFHJojo=")
  file2 = URI.open("https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YnVyZ2VyfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60")
  file3 = URI.open("https://images.unsplash.com/photo-1579871494447-9811cf80d66c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80")
  file4 = URI.open("https://images.unsplash.com/photo-1579871494447-9811cf80d66c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80")

  puts "About to attach images..."
  dish.photos.attach(io: file1, filename: "toad.png", content_type: "image/png")
  dish.photos.attach(io: file4, filename: "toad.png", content_type: "image/png")
  # puts "1 done..."
  dish.photos.attach(io: file2, filename: "cheeseburger.png", content_type: "image/png")
  # puts "2 done..."
  dish.photos.attach(io: file3, filename: "sushi.png", content_type: "image/png")

  dish.save!

  ingredients.each do |ingredient|
    Ingredient.create!(name: ingredient, dish: dish)
  end
end

menu = Menu.create!(restaurant_name: "Luigi's", user: christian)
create_dish_with_ingredients("cheeseburger", %w[beef cheese onions ketchup], menu)
create_dish_with_ingredients("sushi", %w[rice fish tofu], menu)
create_dish_with_ingredients("toadinhole", %w[sausage pudding onion vegetables], menu)
create_dish_with_ingredients("spaghetti puttanesca", %w[oil onion garlic tomatoes], menu)
create_dish_with_ingredients("creamy mushroom pasta", %w[oil butter garlic cream], menu)

puts "Users created: #{User.count}"
puts "Menus created: #{Menu.count}"
puts "Dishes create: #{Dish.count}"
puts "Ingredients create: #{Ingredient.count}"
