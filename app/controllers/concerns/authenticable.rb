module Authenticable
	
	def current_user
		@current_user ||=User.find_by(auth_token: request.headers['Authorization'])
	end
	
	def authenticate_with_token!
		render new_user_session_path,
		status: :unauthorized unless user_signed_in?
	end
	
	def user_signed_in?
		current_user.present?
	end
end