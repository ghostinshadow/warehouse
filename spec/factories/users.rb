FactoryGirl.define do
  factory :user do
    name "Test User"
    sequence(:email){|n| "test#{n}@example.com" }
    password "please123"
    role "user"

    factory :admin do
      role 'admin'
    end

    factory :guest do
      role 'guest'
    end

  end
end
