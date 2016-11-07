FactoryGirl.define do
  factory :permission do
    identifier { FFaker::Lorem.sentence.gsub(/\s+/, '.').underscore }

    trait(:pure) {}
  end

  factory :roles_permission do
    association :role
    association :permission

    trait(:pure) do
      role nil
      permission nil
    end
  end
end