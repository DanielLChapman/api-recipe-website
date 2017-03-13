require 'spec_helper'

RSpec.describe SessionsController, type: :controller do

	describe "POST #create" do
		
		before(:each) do
			@user = FactoryGirl.create :user
		end
		
		context "When the credentitals are correct" do
			before(:each) do
				credentials = { email:@user.email, password: "12345678"}
				post :create, params: { session: credentials }
			end
			
			it "returns the user record corresponding to the given credentials" do
				@user.reload
				json_response[:auth_token].should eql @user.auth_token
			end
			
			it { should respond_with 200 }
		end
		
		context "when the credentials are incorrect" do
			before(:each) do
				credentials = { email: @user.email, password: "invalidpassword" }
				post :create, params: { session: credentials }
			end
			
			it "returns a json with an error" do
				json_response[:errors].should eql "Invalid email or password"
			end
			
			it { should respond_with 422 }
		end
	
	end
end
