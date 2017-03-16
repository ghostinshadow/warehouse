FactoryGirl.define do
  factory :word do
    body "MyString"
    association :dictionary, factory: :units_dictionary
    factory :square_meter do
      body "m2"
    end
    
    factory :cubic_meter do
      body "m3"
    end
  end
end