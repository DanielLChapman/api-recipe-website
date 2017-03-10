require 'spec_helper'

class UsersController < ApplicationController
	
	def show
		@user = User.find(params[:id])
		respond_to do |format|
			format.html
			format.json
		end
	end
	
	def create
		user = User.new(user_params)
		if user.save
			render json: user, status: 201, location: [user]
		else
			render json: { errors: user.errors }, status: 422
		end
	end
	
	def update
		user = User.find(params[:id])
		
		if user.update(user_params)
			render json: user, status: 200, location: [user]
		else
			render json: {errors: user.errors }, status: 422
		end
	end
	
	def destroy
		user = User.find(params[:id])
		user.destroy
		head 204
	end
	
	private

		def user_params
		  	params.require(:user).permit(:email, :password, :password_confirmation)
		end
end
