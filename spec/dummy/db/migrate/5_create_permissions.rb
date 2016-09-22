class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
        t.string   :identifier, null: false
        t.datetime :created_at, null: false
        t.datetime :updated_at, null: false
      end

      add_index :permissions, [:identifier], name: :index_permissions_on_identifier, unique: true
  end
end
