FactoryGirl.define do
  factory :shipping do
    package_variant "MyString"
    shipping_date "2017-03-27"
    factory :income_shipping do
      association(:project_prototype, factory: :three_materials)
      package_variant "IncomePackage"
    end

    factory :outcome_shipping do
      association(:project_prototype, factory: :two_materials)
      package_variant "OutcomePackage"
    end
  end
end
