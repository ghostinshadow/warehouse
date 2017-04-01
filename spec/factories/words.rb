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

    factory :metal do
      body "metal"
      after(:create) do |word|
        create(:subcategory_dictionary, word: word)
      end
    end

    factory :bottom do
      body "bottom"
      after(:create) do |word|
        create(:subcategory_dictionary, word: word)
      end
    end

    factory :bottom_5 do
      body "500mm"
    end

    factory :bottom_7 do
      body "700mm"
    end

    factory :thin_metal do
      body "5mm"
    end

    factory :thick_metal do
      body "20mm"
    end

    factory :human_work do
      body "Human work"
    end

    factory :human_hours do
      body "h/h"
    end
  end
end
