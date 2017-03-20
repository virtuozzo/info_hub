class AddSystemToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :system, :boolean, default: false, null: false
  end
end
