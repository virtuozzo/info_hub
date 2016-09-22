FactoryGirl.define do
  factory :restrictions_sets_resource, class: 'Restrictions::SetsResource' do
    association :set, class: 'Restrictions::Set'
    association :resource, class: 'Restrictions::Resource'

    trait :pure do
      set nil
      resource nil
    end
  end
end
