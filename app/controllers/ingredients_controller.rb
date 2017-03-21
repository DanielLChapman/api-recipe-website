class IngredientsController < ApplicationController
	
	before_action :authenticate_with_token!, only: [:create, :update, :destroy]
	respond_to :json
	
	def index
		@recipe = Recipe.where("id=?", params[:recipe_id])
		@ingredients = @recipe[0].ingredients
		respond_to do |format|
			format.json
		end
	end
	
	def update
		recipe = Recipe.find(params[:recipe_id])
		ingredient = recipe.ingredients.find(params[:id])
		if ingredient.update(ingredient_params)
      		render json: ingredient, status: 200, location: [recipe, ingredient]
		else
			render json: { errors: ingredient.errors }, status: 422
		end
	end
	
	def create
		recipe = Recipe.find(params[:recipe_id])
		ingredient = recipe.ingredients.build(ingredient_params)
		
		if ingredient.save
			render json: ingredient, status: 201
		else
			render json: {errors: ingredient.errors }, status: 422
		end
	end
	
	private
	
		def ingredient_params
			params.require(:ingredient).permit(:name, :amount, :recipe_id)
		end
	
end
