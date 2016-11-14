class UsersRole < OnApp::Models::Base
  belongs_to :user
  belongs_to :role, counter_cache: :users_count

  validates :role_id, presence: true
  validates :user_id, uniqueness: {scope: :role_id}
end
