FactoryGirl.define do
  factory :restrictions_set, class: 'Restrictions::Set' do
    label { Faker::Lorem.sentence }
    sequence(:identifier) { |n| "identifier#{n}"}

    trait :pure do
    end

    trait :vcloud do
      identifier 'vcloud'
      # components tests are failing with InfoHub.get(:restrictions, :default_vcloud_set)
    end
  end
end
