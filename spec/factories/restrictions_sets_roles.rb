FactoryGirl.define do
  factory :restrictions_sets_role, class: 'Restrictions::SetsRole' do
    association :set, class: 'Restrictions::Set'
    association :role

    trait :pure do
      set nil
      role nil
    end
  end
end
