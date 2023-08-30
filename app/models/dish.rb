class Dish < ApplicationRecord
  has_many :ingredients
  belongs_to :menu
  has_many_attached :photos
end
