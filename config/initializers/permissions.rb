Permissions.user_class_name = 'User'

Permissions::Factory.tap do |f|
  f.define_trait :crud do
    actions :create, :read, :update, :delete
  end

  f.define_trait :crud_own do
    action :create
    actions :read, :update, :delete, :scopes => :own
  end

  f.define_trait :vm_actions do
    actions :create, :change_owner, :suspend, :unlock
    actions :migrate, :boot_from_iso, :power, :rebuild_network, :read, :update, :delete,
            :scopes => :own
  end
end

Permissions::Factory.tap do |f|
  f.define :settings => :settings do
    actions :read, :update, :restart_dashboard_client, :version, :manage_ssl_certificate
  end

  f.define :user do
    use_traits :crud_own
    actions :update_api_key, :change_password, :update_yubikey, :connect_aws, :scopes => :own
    actions :suspend, :login_as, :avatar, :generate_new_password_email

    action :read_prices do
      action :read_billing_plan_price, :key => :billing_plan
      action :read_outstanding_amount, :key => :outstanding_amount
      action :read_summary_payments, :key => :summary_payments
      action :read_hourly_price, :key => :hourly_price
      action :read_monthly_price, :key => :monthly_price
      action :read_total_cost, :key => :total_cost
      action :read_vm_prices, :key => :vm_prices
      action :read_backups_templates_price, :key => :backups_templates
    end

    alias_actions :profile, :limits, :hv_limits, :show_usergroup, :of => :read
    alias_actions :validate, :validate_login, :of => :create
    alias_actions :activate, :editprofile, :validate_password, :edit_usergroup,
                  :update_usergroup, :of => :update
    alias_actions :make_new_api_key, :of => :update_api_key
    alias_actions :confirm_destroy, :of => :delete
  end
end
