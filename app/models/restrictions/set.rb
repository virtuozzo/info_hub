module Restrictions
  class Set < OnApp::Models::Base
    attr_accessible :label, :identifier, :resource_ids, :role_ids
    attr_readonly :identifier

    has_many :sets_roles, class_name: 'Restrictions::SetsRole', dependent: :destroy
    has_many :roles, through: :sets_roles
    has_many :sets_resources, class_name: 'Restrictions::SetsResource', dependent: :destroy
    has_many :resources, through: :sets_resources

    validates :identifier, uniqueness: true
    validates :label, presence: true, uniqueness: true
  end
end