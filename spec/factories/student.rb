FactoryBot.define do
  factory :student do
    sequence :email do |n|
      "student#{n}@example.com"
    end
  end
end
