class RecipesController < ApplicationController
	respond_to :json
	
	def show
		@recipe = Recipe.find(params[:id])
		respond_to do |format|
			format.html
			format.json
		end
	end
	
	def index
		@recipe = Recipe.all
		respond_to do |format|
			format.json
		end
	end
end
