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
			get :index, params: {format: :json}
		end
		
		it "returns 4 records from the database" do
			recipes_response = json_response
			expect(recipes_response.length).to eql(4)
		end
		
		it { should respond_with 200 }
	end
	
	describe "POST #create" do
		context "when is successfully created" do
			before(:each) do
				user = FactoryGirl.create :user
				@recipe_attributes = FactoryGirl.attributes_for :recipe
				api_authorization_header user.auth_token
				post :create, params: {user_id: user.id, recipe: @recipe_attributes }
			end
			
			it "Renders the json representative when successfully created" do
				recipe_response = json_response
				expect(recipe_response[:title]).to eql @recipe_attributes[:title]
			end
			
			it { should respond_with 201 }
		end
		
		context "when is not created" do
			before(:each) do
				user = FactoryGirl.create :user
				@invalid_attributes = { title: "ddd", meal: "Poo" }
				api_authorization_header user.auth_token
				post :create, params: {user_id: user.id, recipe: @invalid_attributes }
			end
			
			it "renders an error" do
				recipe_response = json_response
				expect(recipe_response).to have_key(:errors)
				
			end
			
			it { should respond_with 422 }
		end
	end
	
	describe "PUT/PATCH #update" do
		before(:each) do
			@user = FactoryGirl.create :user
			@recipe = FactoryGirl.create :recipe, user: @user
			api_authorization_header @user.auth_token
		end
		
		context "when is successfully updated" do
			before(:each) do 
				patch :update, params: { user_id: @user.id, id: @recipe.id, recipe: {title: "An expensive donut" } }
			end
			
			it "renders the json representation for the update" do
				recipe_response = json_response
				expect(recipe_response[:title]).to eql "An expensive donut"
			end
			
			it { should respond_with 200 }
			
		end
		
		
		context "when is not updated" do
			before(:each) do
				patch :update, params: { user_id: @user.id, id: @recipe.id, recipe: { meal: "Bananas" } }
			end
			
			it "renders an errors json" do
				recipe_response = json_response
				expect(recipe_response).to have_key(:errors)
			end
			
			it { should respond_with 422 }
		end
	end
	
	describe "DELETE #destroy" do
		before(:each) do
			@user = FactoryGirl.create :user
			@recipe = FactoryGirl.create :recipe, user: @user
			api_authorization_header @user.auth_token
			delete :destroy, params: {user_id: @user.id, id: @recipe.id }
		end
		
		it { should respond_with 204 }
	end
end
