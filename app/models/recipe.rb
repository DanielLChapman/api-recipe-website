class Recipe < ApplicationRecord
	MEAL_NAMES = %w(Breakfast Lunch Dessert Snack Dinner)
	validates :title, :description, :meal, :user_id, presence: true
	validates_inclusion_of :meal, :in => MEAL_NAMES
	
	belongs_to :user
	has_many :steps, dependent: :destroy
	has_many :ingredients, dependent: :destroy
	
	def self.search(params = {})
		recipes = params[:recipe_ids].present?? Recipe.find(params[:recipe_ids]):Recipe.all
		
		recipes = recipes.filter_by_title(params[:keyword_title]) if params[:keyword_title]
		recipes = recipes.filter_by_meal(params[:meal]) if params[:meal]
		
		recipes
	end
	
	scope :filter_by_title, lambda { |keyword| 
		where("lower(title) LIKE ?", "%#{keyword.downcase}%" )
		}
	scope :filter_by_meal, lambda { |keyword| 
		where("lower(meal) LIKE ?", "%#{keyword.downcase}%" )
		}
end
