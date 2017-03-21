FactoryGirl.define do
  factory :ingredient do
    recipe
    amount { FFaker::Book.description }
    name { FFaker::Book.description }
  end
end
