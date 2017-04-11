FactoryGirl.define do
  factory :project_prototype do
    name "Project 23"
    structure ""
    factory :three_materials do
      structure { {"1": 10, "2": 20} }
    end

    factory :two_materials do
      prototypable_type "Shipping"
      structure { {"2": 5, "3": 10} }
    end
  end
end
