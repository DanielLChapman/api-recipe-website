FactoryGirl.define do
  factory :recipe do
    title { FFaker::Product.product_name }
    description { FFaker::Book.description }
    meal "Breakfast"
    picture { FFaker::Avatar.image }
	url { FFaker::Avatar.image }
    user
  end
end
