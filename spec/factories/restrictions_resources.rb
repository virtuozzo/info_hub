FactoryGirl.define do
  factory :restrictions_resource, class: 'Restrictions::Resource' do
    sequence(:identifier) do |n|
      types = I18n.t('restrictions.resources').keys.shuffle
      types[n % types.length]
    end
    restriction_type 'by_user_group'

    trait :pure do
    end
  end
end
