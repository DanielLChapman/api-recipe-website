require 'spec_helper'

describe UsersController do

	render_views 
	describe "GET #show" do
		before(:each) do
			@user = FactoryGirl.create :user
			get :show, params: {id: @user.id }, format: :json
		end
		
		it "returns the information about a reporter on a hash" do
			user_response = json_response
			user_response[:email].should eql @user.email
		end
		
		it { should respond_with 200 }
	end
	
	describe "POST #create" do
		context "When is successfully created" do 
			before(:each) do
				@user_attributes = FactoryGirl.attributes_for :user
				post :create, params: { user: @user_attributes }, format: :json
			end

			it "renders the json representation for the user record just created" do
				user_response = json_response
				user_response[:email].should eql @user_attributes[:email]
			end

			it { should respond_with 201 }
		end
		
		context "when is not created" do
			before(:each) do
				@invalid_user_attributes = { password: "12345678", password_confirmation: "12345678" }
				post :create, params: { user: @invalid_user_attributes }, format: :json
			end
			
			it "renders an errors json" do
				user_response = json_response
				user_response.should have_key(:errors)
			end
			
			it "renders the json errors on why the user could not be created" do
				user_response = json_response
				user_response[:errors][:email].should include "can't be blank"
			end
			
			it {should respond_with 422}
		end
	end
	
	describe "PUT/PATCH #update" do
		context "when is successfully updated" do
			before(:each) do
				@user = FactoryGirl.create :user
				patch :update, params: { id: @user.id,
                         user: { email: "newmail@example.com" } }, format: :json
			end
			
			it "renders the json representation for the updated user" do
				user_response = json_response
				user_response[:email].should eql "newmail@example.com"
			end
			
			it { should respond_with 200 }
		end
		
		context "when is not updated" do
			before(:each) do
				@user = FactoryGirl.create :user
				patch :update, params: {id: @user.id, user: {email: "newmailbademailexample.com"} }, format: :json
			end
			
			it "renders an errors json" do
				user_response = json_response
				user_response.should have_key(:errors)
			end
			
			it "renders the json errors on why the user could not be updated" do
				user_response = json_response
				user_response[:errors][:email].should include "is invalid"
			end
			
			it {should respond_with 422 }
				
		end
	end
	
	describe "DELETE #destroy" do
		before(:each) do
			@user = FactoryGirl.create :user
			delete :destroy, { id: @user.id }, format: :json
		end
		
		it {should respond_with 204 }
	end
	
end
