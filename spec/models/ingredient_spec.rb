require 'spec_helper'

RSpec.describe Ingredient, type: :model do
	before { @ingr = FactoryGirl.build(:ingredient) }

  	subject { @ingr }
	
	it { is_expected.to respond_to(:amount) }
	it { is_expected.to respond_to(:name) }
	
	it { is_expected.to validate_presence_of :amount }
	it { is_expected.to validate_presence_of :name }
	
	it { is_expected.to belong_to(:recipe) }
end
