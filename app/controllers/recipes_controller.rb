class RecipesController < ApplicationController
	before_action :authenticate_with_token!, only: [:create, :update, :destroy]
	respond_to :json
	def show
		@recipe = Recipe.find(params[:id])
		@steps = Step.where("recipe_id=?", @recipe.id).order(:order)
		@ingredients = Ingredient.where("recipe_id=?", @recipe.id)
		respond_to do |format|
			format.html
			format.json
		end
	end
	
	def new
		@recipe = Recipe.new
	end
	
	def edit 
		@recipe = Recipe.find(params[:id])
	end
	
	def index
		@recipe = Recipe.search(params)
		respond_to do |format|
			format.html
			format.json
		end
	end
	
	def create
		Rails.logger.info params[:picture]
		recipe = current_user.recipes.build(recipe_params)
		if recipe.save
			render json: recipe, status: 201, location: [recipe]
		else
			render json: { errors: recipe.errors}, status: 422
		end
	end
	
	def update
		recipe = current_user.recipes.find(params[:id])
		if recipe.update(recipe_params)
      		render json: recipe, status: 200, location: [recipe]
		else
			render json: { errors: recipe.errors }, status: 422
		end
	end
	
	def destroy
		recipe = current_user.recipes.find(params[:id])
		recipe.destroy
		head 204
	end
	
	private
	
		def recipe_params
			params.require(:recipe).permit(:title, :description, :meal, :picture, :url)
		end
end
