require 'spec_helper'

RSpec.describe SessionsController, type: :controller do

	describe "POST #create" do
		
		before(:each) do
			@user = FactoryGirl.create :user
		end
		
		context "When the credentitals are correct" do
			before(:each) do
				credentials = { email:@user.email, password: "12345678"}
				post :create, params: { user: credentials }
			end
			
			it "returns the user record corresponding to the given credentials" do
				@user.reload
				expect(json_response[:auth_token]).to eql @user.auth_token
			end
			
			it { is_expected.to respond_with 200 }
		end
		
		context "when the credentials are incorrect" do
			before(:each) do
				credentials = { email: @user.email, password: "invalidpassword" }
				post :create, params: { user: credentials }
			end
			
			it "returns a json with an error" do
				expect(json_response[:errors]).to eql "Invalid email or password"
			end
			
			it { is_expected.to respond_with 422 }
		end
	
	end
	
	describe "DELETE #destroy" do
		before(:each) do
			@user = FactoryGirl.create :user
			sign_in @user
			delete :destroy, params: { id: @user.auth_token }
		end
		
		it { is_expected.to respond_with 204 }
	end
end
