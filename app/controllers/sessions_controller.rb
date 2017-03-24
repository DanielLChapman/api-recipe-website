class SessionsController < ApplicationController
	
	respond_to :json
	skip_before_aaction :authenticate_with_token!
	
	def create
		user_password = params[:user][:password]
		user_email = params[:user][:email]
		user = user_email.present? && User.find_by(email: user_email)
		
		 if user && user.valid_password?(user_password)
			user.reload
			sign_in user, store: false
			user.generate_authentication_token!
			user.save
			render json: user, status: 200, location: [user]
		else
			render json: { errors: "Invalid email or password", user_password: user_password, email: user_email }, status: 422
		end
	end
	
	def destroy
		user = User.find_by(auth_token: params[:id])
		user.generate_authentication_token!
		user.save
		head 204
	end
end
