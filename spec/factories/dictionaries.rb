FactoryGirl.define do
  factory :dictionary do
    title "MyString"
    words_count 1
    factory :materials_dictionary do
      title "Materials"
      type "MaterialsDictionary"
      after(:create) do |dict|
        create(:metal, dictionary: dict)
      end
    end

    factory :units_dictionary do
      title "Units"
      type "UnitsDictionary"
      after(:create) do |dict|
        create(:cubic_meter, dictionary: dict)
        create(:square_meter, dictionary: dict)
      end
    end

    factory :subcategory_dictionary do
      title "Subcategory"
      type "CategorySubtypes"
      association :word , factory: :metal
      after(:create) do |dict|
        create(:thin_metal, dictionary: dict)
        create(:thick_metal, dictionary: dict)
      end
    end
  end
end
