FactoryBot.define do
  factory :reading do
    pm25 { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    pm10 { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    pm100 { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    co2 { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    temperature { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    relative_humidity { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    battery_level { Faker::Number.between(from: 1, to: 100) }
    timestamp { Time.zone.now }
    sensor
  end
end