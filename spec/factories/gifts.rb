FactoryGirl.define do
  factory :gift do
    sequence(:title) { |n| "gift-title-#{n}" }
    sequence(:index) { |n| n }
    slug_image "balls.png"
    sent_by "mail"
  end
end
