class PagesController < ApplicationController
	def show
		Rails.logger.info current_user
	end
	
	def admin
		Rails.logger.info current_user
	end
end
