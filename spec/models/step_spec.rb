require 'spec_helper'

RSpec.describe Step, type: :model do
	before { @step = FactoryGirl.build(:step) }

  	subject { @step }
	
	it { is_expected.to respond_to(:instruction) }
	it { is_expected.to respond_to(:order) }
	
	it { is_expected.to validate_presence_of :instruction }
	it { is_expected.to validate_presence_of :order }
	it { is_expected.to validate_numericality_of(:order).is_greater_than_or_equal_to(1) }
	
	it { is_expected.to belong_to(:recipe) }
	
	describe ".filter_by_instruction" do
		before(:each) do
			@user = FactoryGirl.create :user
			@recipe1 = FactoryGirl.create :recipe, title: "Simply Bread", meal: "Breakfast", user: @user
			@step1 = FactoryGirl.create :step, recipe: @recipe1, instruction: "Boo ate this before"
			@step2 = FactoryGirl.create :step, recipe: @recipe1, instruction: "Boo powered through this before"
			@step3 = FactoryGirl.create :step, recipe: @recipe1, instruction: "Boo dominated this before"
			@step4 = FactoryGirl.create :step, recipe: @recipe1, instruction: "Boo ate this every day"
		end
		
		context "When a 'ATE' instruction pattern is sent" do
			it "returns the 3 recipes matching" do
				expect(Step.filter_by_instruction("ate").length).to eql(3)
			end
			
			it "returns the recipes matching" do
				expect(Step.filter_by_instruction("ate").sort).to match_array([@step1, @step3, @step4])
			end
		end
	end
end
