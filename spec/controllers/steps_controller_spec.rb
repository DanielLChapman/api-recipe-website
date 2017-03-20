require 'spec_helper'

RSpec.describe StepsController, type: :controller do

	render_views
	describe "POST #create" do
		before(:each) do
			@user = FactoryGirl.create :user
			api_authorization_header @user.auth_token
			@recipe = FactoryGirl.create :recipe, user: @user
			post :create, params: { recipe_id: @recipe.id, step: { order: 1, instruction: "blahblahblah"}, format: :json }
		end
		
		it "returns the JSON step record" do
			step_response = json_response
			expect(step_response[:id]).to be_present
		end
		
		it { should respond_with 201 }
	end
	
	describe "GET #index" do
		before(:each) do
			@recipe = FactoryGirl.create :recipe
			@step1 = FactoryGirl.create :step, recipe: @recipe, order: 2
			@step2 = FactoryGirl.create :step, recipe: @recipe, order: 4
			@step3 = FactoryGirl.create :step, recipe: @recipe, order: 6
			@step4 = FactoryGirl.create :step, recipe: @recipe, order: 1
			get :index, params: {recipe_id: @recipe.id, format: :json}
		end
		
		it "returns 4 records from the database" do
			recipes_response = json_response
			expect(recipes_response[:steps].length).to eql(4)
		end
		
		it "should be in order" do
			steps_response = json_response
			expect(steps_response[:steps][0][:order]).to eql(1)
			expect(steps_response[:steps][1][:order]).to eql(2)
		end
		
		
		it { should respond_with 200 }
	end
	
	describe "PUT/PATCH #update" do
		before(:each) do
			@user = FactoryGirl.create :user
			api_authorization_header @user.auth_token
			@recipe = FactoryGirl.create :recipe, user: @user
			@step = FactoryGirl.create :step, recipe: @recipe
		end
		
		context "when is successfully updated" do
			before(:each) do 
				patch :update, params: { recipe_id: @recipe.id, id: @step.id, step: { instruction: "An expensive donut" } }
			end
			
			it "renders the json representation for the update" do
				step_response = json_response
				expect(step_response[:instruction]).to eql "An expensive donut"
			end
			
			it { should respond_with 200 }
			
		end
		
		
		context "when is not updated" do
			before(:each) do
				patch :update, params: { recipe_id: @recipe.id, id: @step.id, step: {instruction: "" } }
			end
			
			it "renders an errors json" do
				step_response = json_response
				expect(step_response).to have_key(:errors)
			end
			
			it { should respond_with 422 }
		end
	end
	
	describe "DELETE #destroy" do
		before(:each) do
			@user = FactoryGirl.create :user
			api_authorization_header @user.auth_token
			@recipe = FactoryGirl.create :recipe, user: @user
			@step = FactoryGirl.create :step, recipe: @recipe
			delete :destroy, params: {recipe_id: @recipe.id, id: @step.id }
		end
		
		it { should respond_with 204 }
	end
end
