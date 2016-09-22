class CreateUsersRoles < ActiveRecord::Migration
  def change
    create_table :users_roles do |t|
      t.integer :user_id, null: false
      t.integer :role_id, null: false
    end

    add_index :users_roles, [:role_id], name: :index_users_roles_on_role_id
    add_index :users_roles, [:user_id], name: :index_users_roles_on_user_id
  end
end
