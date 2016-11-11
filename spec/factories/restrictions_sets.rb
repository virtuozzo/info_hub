FactoryGirl.define do
  factory :restrictions_set, class: 'Restrictions::Set' do
    label { Faker::Lorem.sentence }
    sequence(:identifier) { |n| "identifier#{n}"}

    trait :pure do
    end
  end
end
