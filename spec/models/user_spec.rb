require 'spec_helper'

describe User do
  	before { @user = FactoryGirl.build(:user) }

  	subject { @user }
	
	it { is_expected.to respond_to(:email) }
	it { is_expected.to respond_to(:password) }
	it { is_expected.to respond_to(:password_confirmation) }
	
	it {is_expected.to be_valid}

	it { is_expected.to validate_presence_of(:email) }
	it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
	it { is_expected.to validate_confirmation_of(:password) }
	it { is_expected.to allow_value('example@domain.com').for(:email) }
	
	it { is_expected.to respond_to(:auth_token) }
	
	it { is_expected.to validate_uniqueness_of(:auth_token) }
	
	it { is_expected.to have_many(:recipes) }
	describe "when email is not present" do
		before { @user.email = " " }
		it { is_expected.not_to be_valid }
	end
	
	describe "#generate_authentication_token!" do
		it "generates a unique token" do
			allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
			#Devise.stub(:friendly_token).and_return("auniquetoken123")
			@user.generate_authentication_token!
			expect(@user.auth_token).to eql "auniquetoken123"
		end
		
		it "generates another token when one is already has been taken" do
			exisiting_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
			@user.generate_authentication_token!
			expect(@user.auth_token).not_to eql exisiting_user.auth_token
		end
	end
	
	describe "Recipe association" do
		before do
			@user.save
			3.times { FactoryGirl.create :recipe, user: @user }
		end
		it "should destroy the associations on delete" do
			recipes = @user.recipes
			@user.destroy
			recipes.each do |recipe|
				expect(Recipe.find(recipe)).to raise_error ActiveRecord::RecordNotFound
			end
		end
	end
end
