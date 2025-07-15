FactoryBot.define do
  factory :sensor do
    name { "#{Faker::Address.street_name} Sensor" }
    sender_id { "!#{Faker::Number.unique.hexadecimal(digits: 8)}" }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    user
  end
end
