FactoryGirl.define do
  factory :project do
    aasm_state "new"
    association(:shipping, factory: :income_shipping)
    factory(:basic_project)
  end
end
