FactoryGirl.define do
  factory :user_white_list do
    sequence(:description) { |n| "User White List #{n}" }
    ip '127.0.0.1'
    user_id '22'

    trait :pure do
      user_id nil
    end
  end
end
