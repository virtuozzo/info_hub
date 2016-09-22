class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string   :label,                      null: false
      t.string   :identifier,                 null: false
      t.datetime :created_at,                 null: false
      t.datetime :updated_at,                 null: false
      t.integer  :users_count, default: 0
    end

    add_index :roles, [:identifier], name: :index_roles_on_identifier, unique: true

    create_table :roles_permissions do |t|
      t.integer :role_id,       null: false
      t.integer :permission_id, null: false
    end

    add_index :roles_permissions, [:permission_id], name: :index_roles_permissions_on_permission_id
    add_index :roles_permissions, [:role_id], name: :index_roles_permissions_on_role_id
  end
end
