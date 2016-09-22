class Permission < OnApp::Models::Base
  has_many :roles_permissions, dependent: :destroy
  has_many :roles, through: :roles_permissions

  validates :identifier, presence: true, uniqueness: true

  attr_accessible :identifier
  attr_readonly :identifier

  API_METHODS = %i(label)

  def self.add_permission(options = {})
    permission = Permission.where(identifier: options[:identifier]).first_or_create! do |permission|
                   permission.label = options[:label] if column_names.include? "label"
                 end
    role_ids = Role.where(identifier: Array(options[:roles])).pluck(:id)

    permission.role_ids = (role_ids + permission.role_ids).uniq
    permission
  end

  def label
    I18n.t("permission.#{ identifier }.label")
  end
end
