class StepsController < ApplicationController
	before_action :authenticate_with_token!, only: [:create, :update, :destroy]
	respond_to :json
	
	def index
		@recipe = Recipe.where("id=?", params[:recipe_id])
		@steps = @recipe[0].steps.order(:order)
		respond_to do |format|
			format.json
		end
	end
	
	def create
		recipe = Recipe.find(params[:recipe_id])
		step = recipe.steps.build(step_params)
		
		if step.save
			render json: step, status: 201
		else
			render json: {errors: step.errors }, status: 422
		end
	end
	
	def update
		recipe = Recipe.find(params[:recipe_id])
		step = recipe.steps.find(params[:id])
		if step.update(step_params)
      		render json: step, status: 200, location: [recipe, step]
		else
			render json: { errors: step.errors }, status: 422
		end
	end
	
	def destroy
		recipe = Recipe.find(params[:recipe_id])
		step = recipe.steps.find(params[:id])
		step.destroy
		head 204
	end
	
	private
	
		def step_params
			params.require(:step).permit(:order, :instruction, :recipe_id)
		end
end
