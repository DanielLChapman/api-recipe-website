class Recipe < ApplicationRecord
	MEAL_NAMES = %w(Breakfast Lunch Dessert Snack Dinner)
	validates :title, :description, :meal, :user_id, presence: true
	validates_inclusion_of :meal, :in => MEAL_NAMES
end
