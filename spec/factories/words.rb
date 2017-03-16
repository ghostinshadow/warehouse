FactoryGirl.define do
  factory :word do
    body "MyString"
    factory :square_meter do
      body "m2"
    end
    
    factory :cubic_meter do
      body "m3"
    end
  end
end
