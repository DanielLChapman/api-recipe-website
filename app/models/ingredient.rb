class Ingredient < ApplicationRecord
  	belongs_to :recipe
	validates :name, :amount, :recipe_id, presence: true
end
