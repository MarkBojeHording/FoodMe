class Menu < ApplicationRecord
  has_many :dishes
  belongs_to :user
  has_one_attached :photo
end
