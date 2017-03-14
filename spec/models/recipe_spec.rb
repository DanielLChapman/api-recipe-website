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
end
