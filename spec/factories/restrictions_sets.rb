FactoryGirl.define do
  factory :restrictions_set, class: 'Restrictions::Set' do
    label { Faker::Lorem.sentence }
    sequence(:identifier) { |n| "identifier#{n}"}

    trait :pure do
    end

    trait :vcloud do
      identifier InfoHub.get(:restrictions, :default_vcloud_set)
    end
  end
end
