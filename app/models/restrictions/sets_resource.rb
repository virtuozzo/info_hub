module Restrictions
  class SetsResource < OnApp::Models::Base
    belongs_to :resource, class_name: 'Restrictions::Resource'
    belongs_to :set, class_name: 'Restrictions::Set'

    validates :resource_id, uniqueness: { scope: :set_id }
  end
end
