require 'spec_helper'

RSpec.describe IngredientsController, type: :controller do
	render_views
	describe "GET #index" do
		before(:each) do
			@recipe = FactoryGirl.create :recipe
			@ingredient1 = FactoryGirl.create :ingredient, recipe: @recipe
			@ingredient2 = FactoryGirl.create :ingredient, recipe: @recipe
			@ingredient3 = FactoryGirl.create :ingredient, recipe: @recipe
			@ingredient4 = FactoryGirl.create :ingredient, recipe: @recipe
			get :index, params: {recipe_id: @recipe.id, format: :json}
		end
		
		it "returns 4 records from the database" do
			ingredient_response = json_response
			expect(ingredient_response[:ingredients].length).to eql(4)
		end
		
		it { should respond_with 200 }
	end
end
