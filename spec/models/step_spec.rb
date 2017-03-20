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
end
