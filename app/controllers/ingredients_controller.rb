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
	
end
