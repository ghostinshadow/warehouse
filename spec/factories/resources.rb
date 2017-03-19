FactoryGirl.define do
  factory :resource do
    type ""
    price_uah "9.99"
    price_usd "9.99"
    price_eur "9.99"
    count 1.5
    factory :countable_resource do
      type "CountableResource"
      association :name, factory: :metal
      association :category, factory: :thin_metal
      association :unit, factory: :cubic_meter
    end

    factory :countless_resource do
        type "CountlessResource"
        association :name, factory: :human_work
        association :unit, factory: :human_hours
    end
  end
end
