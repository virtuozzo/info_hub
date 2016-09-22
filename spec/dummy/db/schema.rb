# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150807072802) do

  create_table "permissions", :force => true do |t|
    t.string   "identifier", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "permissions", ["identifier"], :name => "index_permissions_on_identifier", :unique => true

  create_table "restrictions_resources", :force => true do |t|
    t.string   "identifier"
    t.string   "restriction_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "restrictions_resources", ["restriction_type"], :name => "index_restrictions_resources_on_restriction_type"

  create_table "restrictions_sets", :force => true do |t|
    t.string   "identifier"
    t.string   "label"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "restrictions_sets_resources", :force => true do |t|
    t.integer  "set_id"
    t.integer  "resource_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "restrictions_sets_resources", ["resource_id"], :name => "index_restrictions_sets_resources_on_resource_id"
  add_index "restrictions_sets_resources", ["set_id"], :name => "index_restrictions_sets_resources_on_set_id"

  create_table "restrictions_sets_roles", :force => true do |t|
    t.integer  "set_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "restrictions_sets_roles", ["role_id"], :name => "index_restrictions_sets_roles_on_role_id"
  add_index "restrictions_sets_roles", ["set_id"], :name => "index_restrictions_sets_roles_on_set_id"

  create_table "roles", :force => true do |t|
    t.string   "label",                      :null => false
    t.string   "identifier",                 :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "users_count", :default => 0
  end

  add_index "roles", ["identifier"], :name => "index_roles_on_identifier", :unique => true

  create_table "roles_permissions", :force => true do |t|
    t.integer "role_id",       :null => false
    t.integer "permission_id", :null => false
  end

  add_index "roles_permissions", ["permission_id"], :name => "index_roles_permissions_on_permission_id"
  add_index "roles_permissions", ["role_id"], :name => "index_roles_permissions_on_role_id"

  create_table "themes", :force => true do |t|
    t.string   "label"
    t.boolean  "active"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "application_title"
    t.string   "logo"
    t.boolean  "disable_logo"
    t.string   "favicon"
    t.boolean  "disable_favicon"
    t.boolean  "powered_by_hide"
    t.string   "powered_by_url"
    t.string   "powered_by_link_title"
    t.string   "powered_by_color"
    t.string   "powered_by_text"
    t.string   "wrapper_background_color"
    t.string   "wrapper_top_background_image"
    t.boolean  "disable_wrapper_top_background_image"
    t.string   "wrapper_bottom_background_image"
    t.boolean  "disable_wrapper_bottom_background_image"
    t.string   "body_background_color"
    t.string   "body_background_image"
    t.boolean  "disable_body_background_image"
    t.text     "html_header"
    t.text     "html_footer"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                   :limit => 40
    t.string   "first_name",              :limit => 100, :default => ""
    t.string   "last_name",               :limit => 100, :default => ""
    t.string   "email",                   :limit => 100
    t.string   "encrypted_password",      :limit => 40
    t.string   "password_salt",           :limit => 40
    t.datetime "activated_at"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
    t.integer  "group_id"
    t.datetime "deleted_at"
    t.string   "time_zone"
    t.string   "api_key"
    t.string   "status"
    t.integer  "billing_plan_id"
    t.datetime "suspend_at"
    t.integer  "user_group_id"
    t.integer  "image_template_group_id"
    t.string   "locale",                                 :default => "en"
    t.string   "aflexi_key"
    t.string   "aflexi_username"
    t.string   "aflexi_password"
    t.string   "cdn_status",                             :default => "INACTIVE"
    t.string   "cdn_account_status",                     :default => "ACTIVE"
    t.integer  "remote_id"
    t.text     "additional_fields"
    t.integer  "firewall_id"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "avatar"
    t.boolean  "use_gravatar"
    t.text     "infoboxes"
    t.datetime "password_changed_at"
    t.float    "total_amount",                           :default => 0.0
    t.string   "registered_yubikey",      :limit => 12
  end

  create_table "users_roles", :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "role_id", :null => false
  end

  add_index "users_roles", ["role_id"], :name => "index_users_roles_on_role_id"
  add_index "users_roles", ["user_id"], :name => "index_users_roles_on_user_id"

end
