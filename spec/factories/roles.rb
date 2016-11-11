FactoryGirl.define do
  factory :role do
    label { Faker::Lorem.sentence }
    identifier { |record| record.label.gsub(/\s+/, '.').underscore }

    trait :with_permission do
      after :build do |r|
        r.permissions << build(:permission)
      end
    end

    trait(:pure) {}

    trait :vcloud do
      label { "vCloud #{ Faker::Lorem.sentence }" }
    end
  end
end