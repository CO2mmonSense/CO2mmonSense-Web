FactoryBot.define do
  factory :api_key do
    name { Faker::Lorem.word }
    association :bearer, factory: :user
  end
end
