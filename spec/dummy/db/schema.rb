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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170328134652) do

  create_table "permissions", force: :cascade do |t|
    t.string   "identifier", limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "permissions", ["identifier"], name: "index_permissions_on_identifier", unique: true, using: :btree

  create_table "restrictions_resources", force: :cascade do |t|
    t.string   "identifier",       limit: 255
    t.string   "restriction_type", limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "restrictions_resources", ["restriction_type"], name: "index_restrictions_resources_on_restriction_type", using: :btree

  create_table "restrictions_sets", force: :cascade do |t|
    t.string   "identifier", limit: 255
    t.string   "label",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "restrictions_sets_resources", force: :cascade do |t|
    t.integer  "set_id",      limit: 4
    t.integer  "resource_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "restrictions_sets_resources", ["resource_id"], name: "index_restrictions_sets_resources_on_resource_id", using: :btree
  add_index "restrictions_sets_resources", ["set_id"], name: "index_restrictions_sets_resources_on_set_id", using: :btree

  create_table "restrictions_sets_roles", force: :cascade do |t|
    t.integer  "set_id",     limit: 4
    t.integer  "role_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "restrictions_sets_roles", ["role_id"], name: "index_restrictions_sets_roles_on_role_id", using: :btree
  add_index "restrictions_sets_roles", ["set_id"], name: "index_restrictions_sets_roles_on_set_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "label",       limit: 255,                 null: false
    t.string   "identifier",  limit: 255,                 null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "users_count", limit: 4,   default: 0
    t.boolean  "system",                  default: false, null: false
  end

  add_index "roles", ["identifier"], name: "index_roles_on_identifier", unique: true, using: :btree

  create_table "roles_permissions", force: :cascade do |t|
    t.integer "role_id",       limit: 4, null: false
    t.integer "permission_id", limit: 4, null: false
  end

  add_index "roles_permissions", ["permission_id"], name: "index_roles_permissions_on_permission_id", using: :btree
  add_index "roles_permissions", ["role_id"], name: "index_roles_permissions_on_role_id", using: :btree

  create_table "themes", force: :cascade do |t|
    t.string   "label",                                   limit: 255
    t.boolean  "active"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "application_title",                       limit: 255
    t.string   "logo",                                    limit: 255
    t.boolean  "disable_logo"
    t.string   "favicon",                                 limit: 255
    t.boolean  "disable_favicon"
    t.boolean  "powered_by_hide"
    t.string   "powered_by_url",                          limit: 255
    t.string   "powered_by_link_title",                   limit: 255
    t.string   "powered_by_color",                        limit: 255
    t.string   "powered_by_text",                         limit: 255
    t.string   "wrapper_background_color",                limit: 255
    t.string   "wrapper_top_background_image",            limit: 255
    t.boolean  "disable_wrapper_top_background_image"
    t.string   "wrapper_bottom_background_image",         limit: 255
    t.boolean  "disable_wrapper_bottom_background_image"
    t.string   "body_background_color",                   limit: 255
    t.string   "body_background_image",                   limit: 255
    t.boolean  "disable_body_background_image"
    t.text     "html_header",                             limit: 65535
    t.text     "html_footer",                             limit: 65535
  end

  create_table "users", force: :cascade do |t|
    t.string   "login",                   limit: 40
    t.string   "first_name",              limit: 100,   default: ""
    t.string   "last_name",               limit: 100,   default: ""
    t.string   "email",                   limit: 100
    t.string   "encrypted_password",      limit: 40
    t.string   "password_salt",           limit: 40
    t.datetime "activated_at"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.integer  "group_id",                limit: 4
    t.datetime "deleted_at"
    t.string   "time_zone",               limit: 255
    t.string   "api_key",                 limit: 255
    t.string   "status",                  limit: 255
    t.integer  "billing_plan_id",         limit: 4
    t.datetime "suspend_at"
    t.integer  "user_group_id",           limit: 4
    t.integer  "image_template_group_id", limit: 4
    t.string   "locale",                  limit: 255,   default: "en"
    t.string   "aflexi_key",              limit: 255
    t.string   "aflexi_username",         limit: 255
    t.string   "aflexi_password",         limit: 255
    t.string   "cdn_status",              limit: 255,   default: "INACTIVE"
    t.string   "cdn_account_status",      limit: 255,   default: "ACTIVE"
    t.integer  "remote_id",               limit: 4
    t.text     "additional_fields",       limit: 65535
    t.integer  "firewall_id",             limit: 4
    t.string   "reset_password_token",    limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           limit: 4,     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",      limit: 255
    t.string   "last_sign_in_ip",         limit: 255
    t.integer  "failed_attempts",         limit: 4,     default: 0
    t.string   "unlock_token",            limit: 255
    t.datetime "locked_at"
    t.string   "avatar",                  limit: 255
    t.boolean  "use_gravatar"
    t.text     "infoboxes",               limit: 65535
    t.datetime "password_changed_at"
    t.float    "total_amount",            limit: 24,    default: 0.0
    t.string   "registered_yubikey",      limit: 12
  end

  create_table "users_roles", force: :cascade do |t|
    t.integer "user_id", limit: 4, null: false
    t.integer "role_id", limit: 4, null: false
  end

  add_index "users_roles", ["role_id"], name: "index_users_roles_on_role_id", using: :btree
  add_index "users_roles", ["user_id"], name: "index_users_roles_on_user_id", using: :btree

end
