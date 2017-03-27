class PagesController < ApplicationController
	def show
	end
	
	def admin
		@adminPage = true
		@recipe = Recipe.new
	end
end
