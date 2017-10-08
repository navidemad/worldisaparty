FactoryGirl.define do
  factory :user do
    sequence(:uid) { |n| "uid-#{n}" }
    sequence(:email) { |n| "user#{n}@example.tld" }
    first_name "firstname"
    last_name "lastname"
    role "admin"
  end
end
