require 'spec_helper'

RSpec.describe Recipe, type: :model do
	before { @recipe = FactoryGirl.build(:recipe) }

  	subject { @recipe }
	
	it { is_expected.to respond_to(:title) }
	it { is_expected.to respond_to(:description) }
	it { is_expected.to respond_to(:meal) }
	it { is_expected.to respond_to(:picture) }
	
	it { is_expected.to validate_presence_of :title }
	it { is_expected.to validate_presence_of :description }
	it { is_expected.to validate_presence_of :meal }
	it { is_expected.to validate_inclusion_of(:meal).in_array(%w[Dinner Breakfast Snack Lunch Dessert] ) }
	
	it { is_expected.to belong_to(:user) }
	
	describe ".filter_by_title" do
		before(:each) do
			@recipe1 = FactoryGirl.create :recipe, title: "Simply Bread", meal: "Breakfast"
			@recipe2 = FactoryGirl.create :recipe, title: "Basically Baroque", meal: "Breakfast"
			@recipe3 = FactoryGirl.create :recipe, title: "Bread around the block", meal: "Breakfast"
			@recipe4 = FactoryGirl.create :recipe, title: "Baked Alaska", meal: "Dinner"
		end
		
		context "when a 'BREAD' title pattern is sent" do
			it "returns the 2 recipes matching" do
				expect(Recipe.filter_by_title("BREAD").length).to eql(2)
			end
			
			it "returns the recipes matching" do
				expect(Recipe.filter_by_title("BREAD").sort).to match_array([@recipe1, @recipe3])
			end
		end
	end
	
	describe ".filter_by_meal" do
		before(:each) do
			@recipe1 = FactoryGirl.create :recipe, title: "Simply Bread", meal: "Breakfast"
			@recipe2 = FactoryGirl.create :recipe, title: "Basically Baroque", meal: "Breakfast"
			@recipe3 = FactoryGirl.create :recipe, title: "Bread around the block", meal: "Breakfast"
			@recipe4 = FactoryGirl.create :recipe, title: "Baked Alaska", meal: "Dinner"
		end
		
		context "When a 'BREAKFAST' title pattern is sent" do
			it "returns the 3 recipes matching" do
				expect(Recipe.filter_by_meal("BREAKFAST").length).to eql(3)
			end
			
			it "returns the recipes matching" do
				expect(Recipe.filter_by_meal("BREAKFAST").sort).to match_array([@recipe1, @recipe2, @recipe3])
				
			end
		end
	end
	
	describe ".search" do
		before(:each) do
			@recipe1 = FactoryGirl.create :recipe, title: "Simply Bread", meal: "Breakfast"
			@recipe2 = FactoryGirl.create :recipe, title: "Baked Basically Baroque", meal: "Breakfast"
			@recipe3 = FactoryGirl.create :recipe, title: "Bread around the block", meal: "Breakfast"
			@recipe4 = FactoryGirl.create :recipe, title: "Baked Alaska", meal: "Dinner"
		end
		
		context "when the title contains bread and the meal is breakfast" do
			it "returns 2 recipes" do
				search_hash = { keyword_title: "bread", meal: "Breakfast" }
				expect(Recipe.search(search_hash)).to match_array([@recipe1, @recipe3])
			end
		end
		
		context "when the title contains Idora and meal is Dinner" do
			it "returns nothing" do
				search_hash = { keyword_title: "Idora", meal: "Dinner" }
				expect(Recipe.search(search_hash)).to be_empty
			end
		end
		
		context "when recipe_ids are present" do
			it "returns 2 recipes" do
				search_hash = { recipe_ids: [@recipe1.id, @recipe2.id] }
				expect(Recipe.search(search_hash)).to match_array([@recipe1, @recipe2])
			end
		end
		
	end
end
