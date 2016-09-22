module Restrictions
  class SetsRole < OnApp::Models::Base
    belongs_to :role
    belongs_to :set, class_name: 'Restrictions::Set'

    validates :role_id, presence: true, uniqueness: { scope: :set_id }
    validates :set_id, presence: true
  end
end