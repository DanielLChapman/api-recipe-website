FactoryGirl.define do
  factory :step do
    instruction { FFaker::Book.description }
    order { FFaker::AddressRU.building_number }
    recipe
  end
end
