module Restrictions
  class SetsResource < OnApp::Models::Base
    belongs_to :resource, class_name: 'Restrictions::Resource'
    belongs_to :set, class_name: 'Restrictions::Set'

    validates :resource_id, presence: true, uniqueness: { scope: :set_id }
    validates :set_id, presence: true
  end
end