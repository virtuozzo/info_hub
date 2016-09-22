class CreateRestrictions < ActiveRecord::Migration
  def change
    create_table :restrictions_resources do |t|
      t.string   :identifier
      t.string   :restriction_type
      t.datetime :created_at,       null: false
      t.datetime :updated_at,       null: false
    end

    add_index :restrictions_resources, [:restriction_type], name: :index_restrictions_resources_on_restriction_type

    create_table :restrictions_sets do |t|
      t.string   :identifier
      t.string   :label
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    create_table :restrictions_sets_resources do |t|
      t.integer  :set_id
      t.integer  :resource_id
      t.datetime :created_at,  null: false
      t.datetime :updated_at,  null: false
    end

    add_index :restrictions_sets_resources, [:resource_id], :name => :index_restrictions_sets_resources_on_resource_id
    add_index :restrictions_sets_resources, [:set_id], :name => :index_restrictions_sets_resources_on_set_id

    create_table :restrictions_sets_roles do |t|
      t.integer  :set_id
      t.integer  :role_id
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    add_index :restrictions_sets_roles, [:role_id], :name => :index_restrictions_sets_roles_on_role_id
    add_index :restrictions_sets_roles, [:set_id], :name => :index_restrictions_sets_roles_on_set_id
  end
end
