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
	
	describe "POST #create" do
		before(:each) do
			@user = FactoryGirl.create :user
			api_authorization_header @user.auth_token
			@recipe = FactoryGirl.create :recipe, user: @user
			post :create, params: { recipe_id: @recipe.id, ingredient: { amount: "one", name: "blahblahblah"}, format: :json }
		end
		
		it "returns the JSON step record" do
			ingredient_response = json_response
			expect(ingredient_response[:id]).to be_present
		end
		
		it { should respond_with 201 }
	end
	
	describe "PUT/PATCH #update" do
		before(:each) do
			@user = FactoryGirl.create :user
			api_authorization_header @user.auth_token
			@recipe = FactoryGirl.create :recipe, user: @user
			@ingredient = FactoryGirl.create :ingredient, recipe: @recipe
		end
		
		context "when is successfully updated" do
			before(:each) do 
				patch :update, params: { recipe_id: @recipe.id, id: @ingredient.id, ingredient: { name: "An expensive donut" } }
			end
			
			it "renders the json representation for the update" do
				ingredient_response = json_response
				expect(ingredient_response[:name]).to eql "An expensive donut"
			end
			
			it { should respond_with 200 }
			
		end
		
		
		context "when is not updated" do
			before(:each) do
				patch :update, params: { recipe_id: @recipe.id, id: @ingredient.id, ingredient: {name: "" } }
			end
			
			it "renders an errors json" do
				ingredient_response = json_response
				expect(ingredient_response).to have_key(:errors)
			end
			
			it { should respond_with 422 }
		end
	end
	describe "DELETE #destroy" do
		before(:each) do
			@user = FactoryGirl.create :user
			api_authorization_header @user.auth_token
			@recipe = FactoryGirl.create :recipe, user: @user
			@ingredient = FactoryGirl.create :ingredient, recipe: @recipe
			delete :destroy, params: {recipe_id: @recipe.id, id: @ingredient.id }
		end
		
		it { should respond_with 204 }
	end
end
