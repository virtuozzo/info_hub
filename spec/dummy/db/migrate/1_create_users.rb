class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :login, limit: 40
      t.string   :first_name, limit: 100, default: ''
      t.string   :last_name, limit: 100, default: ''
      t.string   :email, limit: 100
      t.string   :encrypted_password, limit: 40
      t.string   :password_salt, limit: 40
      t.datetime :activated_at
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.integer  :group_id
      t.datetime :deleted_at
      t.string   :time_zone
      t.string   :api_key
      t.string   :status
      t.integer  :billing_plan_id
      t.datetime :suspend_at
      t.integer  :user_group_id
      t.integer  :image_template_group_id
      t.string   :locale, default: 'en'
      t.string   :aflexi_key
      t.string   :aflexi_username
      t.string   :aflexi_password
      t.string   :cdn_status, default: 'INACTIVE'
      t.string   :cdn_account_status, default: 'ACTIVE'
      t.integer  :remote_id
      t.text     :additional_fields
      t.integer  :firewall_id
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer  :sign_in_count, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      t.integer  :failed_attempts, default: 0
      t.string   :unlock_token
      t.datetime :locked_at
      t.string   :avatar
      t.boolean  :use_gravatar
      t.text     :infoboxes
      t.datetime :password_changed_at
      t.float    :total_amount, default: 0.0
      t.boolean  :supplied, default: false
      t.text     :system_theme, limit: 65535
      t.string   :aws_access_key_id, limit: 255
      t.string   :aws_secret_access_key, limit: 255
      t.string   :identifier, limit: 255
    end
  end
end
