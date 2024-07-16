FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    category { "Sample Category" }
    default_price { 100.0 }
    qty { 50 }
  end
end
