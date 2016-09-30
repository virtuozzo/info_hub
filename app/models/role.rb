class Role < OnApp::Models::Base
  concerned_with *Core.concerns.fetch(:role, [])

  has_many :roles_permissions, dependent: :destroy
  has_many :permissions, through: :roles_permissions
  has_many :users_roles
  has_many :users, through: :users_roles, after_remove: :decrement_users_count
  has_many :sets_roles, class_name: 'Restrictions::SetsRole', dependent: :destroy
  has_many :sets, through: :sets_roles
  has_many :restricted_resources, source: :resources, through: :sets

  validates :label, presence: true, uniqueness: true
  validates :identifier, uniqueness: true, allow_nil: true

  attr_accessible :label, :permission_ids, :identifier
  attr_readonly :identifier

  scope :all_by_permissions, lambda { |*permission| joins(:permissions).where('permissions.identifier IN (?)', permission.flatten) }
  scope :admin,   -> { where(identifier: admin_role_identifiers.flatten) }
  scope :by_user, ->(value) { where(id: value.role_ids) }

  API_METHODS = [:permissions]

  def reset_users_counter
    stmt = Role.where(id: id).arel.compile_update(Role.arel_table[:users_count] => users.count)
    self.class.connection.update stmt
  end

  def self.find_admin_id
    admin_role = admin.first
    if admin_role
      admin_role.id
    elsif count <= 2
      1
    end
  end

  def self.admin_role_identifiers
    ids = InfoHub.get(:role, :admin_roles) rescue nil
    ids || ['admin']
  end

  def serializable_hash(options = {})
    hash = super
    hash.delete('users_count') unless options[:show_users_count]

    hash
  end

  protected

  def decrement_users_count(user)
    Role.decrement_counter(:users_count, id)
  end
end
