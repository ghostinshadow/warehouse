FactoryGirl.define do
  factory :dictionary do
    title "MyString"
    words_count 1
    factory :materials_dictionary do
      type "MaterialsDictionary"
    end

    factory :units_dictionary do
      type "UnitsDictionary"
    end
  end
end
