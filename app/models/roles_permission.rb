class RolesPermission < OnApp::Models::Base
  belongs_to :role
  belongs_to :permission

  validates :role_id, presence: true
  validates :permission_id, presence: true
end
