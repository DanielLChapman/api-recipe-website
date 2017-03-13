require 'spec_helper'

describe User do
  	before { @user = FactoryGirl.build(:user) }

  	subject { @user }
	
	it { should respond_to(:email) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	
	it {should be_valid}

	it { should validate_presence_of(:email) }
	it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
	it { should validate_confirmation_of(:password) }
	it { should allow_value('example@domain.com').for(:email) }
	
	it { should respond_to(:auth_token) }
	
	it { should validate_uniqueness_of(:auth_token) }
	
	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end
	
	describe "#generate_authentication_token!" do
		it "generates a unique token" do
			Devise.stub(:friendly_token).and_return("auniquetoken123")
			@user.generate_authentication_token!
			@user.auth_token.should eql "auniquetoken123"
		end
		
		it "generates another token when one is already has been taken" do
			exisiting_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
			@user.generate_authentication_token!
			@user.auth_token.should_not eql exisiting_user.auth_token
		end
	end
end
