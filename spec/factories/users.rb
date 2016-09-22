# check if factory :user is defined (if Core factories are being used in main app specs) before defining it
unless FactoryGirl.factories.registered?(:user)
  FactoryGirl.define do
    factory :user do
      email 'john@gmail.com'

      trait :pure
    end
  end
end
