class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
	
	include Authenticable
	
	before_action :set_admin_val
	
	def set_admin_val 
		@adminPage = false
		Rails.logger.info @adminPage
	end
	
end
