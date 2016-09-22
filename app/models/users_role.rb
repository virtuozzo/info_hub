class UsersRole < OnApp::Models::Base
  belongs_to :user
  belongs_to :role, counter_cache: :users_count

  validates :user_id, presence: true
  validates :role_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :role_id }
end
