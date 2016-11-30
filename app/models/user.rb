class User < OnApp::Models::Base
  concerned_with :infobox_methods, :theme_methods, *Core.concerns.fetch(:user, [])

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :lockable, :encryptable,
         :password_expirable, :omniauthable, :yubikey_database_authenticatable, omniauth_providers: [:saml, :facebook, :google]

  include Permissions::UserModelMethods.attached_to(:permissions) # Have to move it here from initializer becouse otherwise
                                                                  # an error pops up undefined method `has_permission?'
                                                                  # Probably, some loading issue
  has_many :users_roles
  has_many :roles, through: :users_roles, dependent: :destroy
  has_many :permissions, through: :roles
  has_many :restricted_resources, through: :roles

  scope :all_by_permissions, ->(*permissions) { joins(roles: :permissions).where('permissions.identifier IN (?)', permissions.flatten) }


  def admin?
    User.joins(:roles).merge(Role.admin).exists?(id: id)
  end
end
