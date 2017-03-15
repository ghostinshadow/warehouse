FactoryGirl.define do
  factory :user do
    name "Test User"
    sequence(:email){|n| "test#{n}@example.com" }
    password "please123"

    trait :admin do
      role 'admin'
    end

  end
end
