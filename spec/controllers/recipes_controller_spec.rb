require 'spec_helper'

RSpec.describe RecipesController do
	
	render_views
	describe "GET #show" do
		before(:each) do
			@user = FactoryGirl.create :user
			@recipe = FactoryGirl.create :recipe, user: @user
			get :show, params: {id: @recipe.id, format: :json}
		end
		
		it "returns the information" do
			recipe_response = JSON.parse(response.body, symbolize_names: true)
			expect(recipe_response[:title]).to eql @recipe.title
		end
		
		it { is_expected.to respond_with 200 }
	end
	
	describe "GET #index" do
		before(:each) do
			4.times { FactoryGirl.create :recipe }
			get :index
		end
		
		it "returns 4 records from the database" do
			recipes_response = json_response
			expect(productS_response[:products]).to have(4).items
		end
		
		it { should respond_with 200 }
	end
end
