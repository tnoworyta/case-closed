FactoryBot.define do
  factory :tutor do
    sequence :email do |n|
      "tutor#{n}@example.com"
    end
  end
end
