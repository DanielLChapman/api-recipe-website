FactoryGirl.define do
  factory :recipe do
    title { FFaker::Product.product_name }
    description { FFaker::Book.description }
    meal "Breakfast"
    picture { FFaker::Avatar.image }
    user_id 1
  end
end
