class Recipe < ApplicationRecord
	MEAL_NAMES = %w(Breakfast Lunch Dessert Snack Dinner)
	validates :title, :description, :meal, :user_id, presence: true
	validates_inclusion_of :meal, :in => MEAL_NAMES
	mount_uploader :picture, PictureUploader
	
	belongs_to :user
	has_many :steps, dependent: :destroy
	has_many :ingredients, dependent: :destroy
	
	def self.search(params = {})
		recipes = params[:recipe_ids].present?? Recipe.find(params[:recipe_ids]):Recipe.all
		#recipes = recipes.filter_by_title(params[:keyword_title]) if params[:keyword_title]
		searchQuery = params[:keyword_title].to_s.split(/\s(?=(?:[^"]|"[^"]*")*$)/)
		recipes = recipes.ransack(title_cont_any: searchQuery).result if params[:keyword_title]
		#params[:keyword_title].downcase.split(/\s(?=(?:[^"]|"[^"]*")*$)/).each do |x|
		#	recipes = recipes.filter_by_title(x)
		#end
		recipes = recipes.filter_by_meal(params[:meal]) if params[:meal]
		
		recipes
	end
	
	scope :filter_by_title, lambda { |keyword| 
		where("lower(title) LIKE ?", "%#{keyword}%")
		}
	scope :filter_by_meal, lambda { |keyword| 
		where("lower(meal) LIKE ?", "%#{keyword.downcase}%" )
		}
end
