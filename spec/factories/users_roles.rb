FactoryGirl.define do
  factory :users_role do
    association :user
    association :role

    trait(:pure) do
      user nil
      role nil
    end
  end
end