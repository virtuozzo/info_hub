class RolesPermission < OnApp::Models::Base
  belongs_to :role
  belongs_to :permission

  validates :role, presence: true
  validates :permission, presence: true
end
