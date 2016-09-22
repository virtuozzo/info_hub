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
  f.define :blueprint,
           :blueprint_template,
           :cdn_resource,
           :cdn_ssl_certificate,
           :schedule,
           :auto_scaling_configuration   => :auto_scalings,
           :dns_zone_record              => :dns_records,
           :dns_zone_record_a            => :dns_records,
           :dns_zone_record_aaaa         => :dns_records,
           :dns_zone_record_cname        => :dns_records,
           :dns_zone_record_mx           => :dns_records,
           :dns_zone_record_ns           => :dns_records,
           :dns_zone_record_soa          => :dns_records,
           :dns_zone_record_srv          => :dns_records,
           :dns_zone_record_txt          => :dns_records,
           :disk_usage_statistic         => :io_stats,
           :federation_supplier_schedule => :schedules,
           :federation_trader_schedule   => :schedules do
    use_traits :crud_own
  end

  f.define :backup_server,
           :billing_currencies_currency,
           :customer_vlan,
           :data_store,
           :group,
           :nameserver,
           :network,
           :org_network,
           :vapp_network,
           :vdc,
           :vcloud_nat_rule,
           :edge_gateway,
           :permission,
           :theme,
           :instance_package,
           :user_additional_field,
           :external_network => :networks,
           :vcloud_data_store => :data_stores do
    use_traits :crud
  end

  f.define :edge_group do
    use_traits :crud
    actions :read_available_locations, :read_locations_price
  end

  f.define :backup,
           :backup_normal => :backups,
           :federation_trader_backup_normal => :backups,
           :federation_supplier_backup_normal => :backups,
           :backup_incremental => :backups,
           :federation_trader_backup_incremental => :backups,
           :federation_supplier_backup_incremental => :backups do
    actions :create, :read, :update, :delete, :convert, :scopes => :own
  end

  # TODO :BILLING => rename permissions in database and rename here
  f.define :billing_user_resource_base => :base_resources,
           :billing_resource_base => :base_resource do
    action :read, :scopes => :own
    actions :create, :update, :delete, :list
  end

  f.define :customer_network,
           :ip_address_join,
           :federation_trader_ip_address_join => :ip_address_joins,
           :federation_supplier_ip_address_join => :ip_address_joins do
    actions :create, :read, :delete, :scopes => :own
  end

  f.define :recipe_group,
           :recipe_group_relation,
           :data_store_group => :data_store_zones,
           :network_group => :network_zones,
           :backup_server_group => :backup_server_zones do
    use_traits :crud
    action :list
  end

  f.define :image_template_group,
           :relation_group_template do
    actions :create, :read, :delete, :update, :scopes => :own
  end

  f.define :ip_address_pool do
    actions :create, :read, :delete
  end

  f.define :data_store_join,
           :backup_server_join do
    actions :create, :delete
  end

  f.define :io_stat,
           :last_access_log_item do
    action :read, :scopes => :own
  end

  f.define :disk,
           :federation_trader_disk => :disks,
           :federation_supplier_disk => :disks do
    use_traits :crud_own
    action :migrate, :scopes => :own
    action :unlock
    action :autobackup, :scopes => :own
  end

  f.define :dns_zone => :dns_zone do
    actions :read, :delete, :scopes => :own
    actions :create, :setup
  end

  f.define :firewall_rule,
           :user_white_list,
           :vcloud_firewall_rule => :firewall_rules,
           :federation_trader_firewall_rule => :firewall_rules,
           :federation_supplier_firewall_rule => :firewall_rules do
    actions :create, :read, :update, :delete, :scopes => :own
  end

  f.define :hypervisor do
    use_traits :crud
    actions :read_vm_creation, :reboot, :maintenance_mode
  end

  f.define :hypervisor_group => :hypervisor_zones do
    use_traits :crud
    actions :read_vm_creation, :list, :recipe_manage
  end

  f.define :hypervisor_device,
           :hypervisor_custom_device => :hypervisor_devices,
           :hypervisor_disk_device => :hypervisor_devices,
           :hypervisor_disk_pci_device => :hypervisor_devices,
           :hypervisor_network_interface_device => :hypervisor_devices do
    actions :read, :update
  end

  f.define :image_template => :templates do
    action :manage, :scopes => [:own, :public, :user]
    action :read, :allowed_by => :manage, :scopes => [:own, :public, :user]
    actions :create, :update, :upgrade, :restart_install, :delete, :make_public, :allowed_by => :manage,
            :scopes => [:own, :user]
    action :recipe_manage, :scopes => :own
    actions :inactive, :available, :upgrades, :installs
  end

  f.define :ip_address do
    use_traits :crud
    actions :assign, :unassign
  end

  f.define :image_template_iso => :isos do
    action :manage, :scopes => [:own, :public, :user]
    action :read, :allowed_by => :manage, :scopes => [:own, :public, :user]
    actions :create, :update, :delete, :make_public, :allowed_by => :manage,
            :scopes => [:own, :user]
  end

  f.define :load_balancing_cluster do
    use_traits :crud_own
    action :asout
  end

  f.define :load_balancer do
    action :migrate, :scopes => :own
  end

  f.define :location_group do
    use_traits :crud
    actions :refresh
  end

  f.define :log_item do
    actions :read, :delete, :list, :scopes => :own
  end

  f.define :transaction do
    actions :cancel_zombie, :delete, :list, :read, :scopes => :own
  end

  f.define :billing_payment => :payments,
           :billing_user_payment => :payments,
           :billing_company_payment => :payments do
    actions :create, :delete, :update
    action :read, :scopes => [:own, :company]
  end

  f.define :recipe do
    action :create
    actions :read, :edit, :delete, :scopes => :own
    alias_actions :update, :of => :edit
  end

  f.define :blueprint_template_group,
           :blueprint_template_group_relation do
    actions :create, :read, :update, :delete, :list
  end

  f.define :role,
           :schedule_log,
           :billing_company_plan,
           :billing_user_plan => :billing_plans do
    action :read, :scopes => :own
    actions :create, :update, :delete
  end

  f.define :billing_company_statistics_vdc_stat do
    actions :read, :scopes => :own
  end

  f.define :restrictions_set do
    actions :create, :update, :delete
    action :read, :scopes => :own
  end

  f.define :restrictions_resource do
    action :read
  end

  f.define :ssh_key do
    action :add, :scopes => :own
    alias_actions :create, :read, :update, :delete, :of => :add
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

  f.define :user_hourly_stat => :cdn_usage_stats do
    action :read, :scopes => :own
  end

  f.define :virtual_machine,
           :smart_server => :virtual_machines,
           :baremetal_server => :virtual_machines do
    use_traits :vm_actions
    actions :console, :reset_root_password, :recipe_manage,
            :manage_publications, :read_root_password, :build, :accelerate, :purge,
            :scopes => :own
    actions :set_ssh_keys, :set_vip,
            :select_instance_package_on_creation, :select_resources_manually_on_creation
    action :read_vip, :allowed_by => :set_vip
    action :cpu_topology
    action :report_federation_problem, :scopes => :own
    action :autobackup, :scopes => :own
    action :install_vmware_tools
    action :toggle_media, :scopes => :own
    alias_actions :reboot, :shutdown, :recovery_reboot, :of => :power
    alias_actions :building, :of => :build
  end

  f.define :federation_supplier_virtual_machine => :virtual_machines do
    strict_mode!
    use_traits :vm_actions
    actions :console, :read_root_password, :reset_root_password, :build,
            :report_federation_problem, :scopes => :own
    alias_actions :reboot, :shutdown, :recovery_reboot, :of => :power
    alias_actions :building, :of => :build
  end

  f.define :federation_trader_virtual_machine => :virtual_machines do
    strict_mode!
    actions :create, :suspend, :unlock
    actions :boot_from_iso, :power, :rebuild_network, :read, :update, :delete,
            :console, :read_root_password, :reset_root_password, :build,
            :report_federation_problem, :scopes => :own
    alias_actions :reboot, :shutdown, :recovery_reboot, :of => :power
    alias_actions :building, :of => :build
  end

  f.define :vm_hourly_stat => :vm_stats,
           :vm_billing_stat => :vm_stats do
    actions :read, :scopes => :own
  end

  f.define :application_server do
    use_traits :vm_actions
    actions :set_vip
    action :read_vip, :allowed_by => :set_vip
  end

  f.define :container_server do
    use_traits :vm_actions
    actions :console, :reset_root_password, :recipe_manage,
              :read_root_password, :build,
              :scopes => :own
    actions :set_vip
    action :read_vip, :allowed_by => :set_vip
    action :cpu_topology
    action :edit_cloud_config, scopes: :own
    alias_actions :reboot, :shutdown, :of => :power
    alias_actions :building, :of => :build
  end

  f.define :accelerator,
           :edge_server,
           :storage_server do
    use_traits    :vm_actions
    action        :set_vip
    action        :build, :scopes => :own
    action        :read_vip, :allowed_by => :set_vip
    alias_actions :reboot, :shutdown, :of => :power
  end

  f.define :virtual_machine_snapshot do
    actions :create, :delete, :read, :scopes => :own
    alias_actions :restore, :build, :of => :create
  end

  f.define :autobackup_template do
    actions :read, :update
  end

  f.define :dashboard => :dashboard do
    actions :alerts,
            :global_stats,
            :licensing,
            :show_cloud_dashboard,
            :show_vcloud_dashboard
  end

  f.define :control_panel => :control_panel do
    action :recipe_manage
  end

  f.define :i18n => :i18n do
    action :manage
  end

  f.define :monitis_monitor, :help => :help do
    action :read
  end

  f.define :user_monthly_stat => :monthly_user_bills do
    action :read, :scopes => :own
  end

  f.define :billing_company_statistics_monthly_stat => :monthly_user_group_bills do
    action :read, :scopes => :own
  end

  f.define :settings => :settings do
    actions :read, :update, :restart_dashboard_client, :version, :manage_ssl_certificate
  end

  f.define :user_group do
    use_traits :crud
    action :list
  end

  f.define :sysadmin_tool,
           :cloud_boot => :cloud_boot,
           :global_search => :global_search,
           :integrated_storage => :integrated_storage,
           :draas => :draas

  f.define :session do
    action :drop_all
    action :drop_others, :allowed_by => :drop_all
  end

  f.define :federation => :federation do
    actions :add, :read, :remove, :status, :subscribe, :unsubscribe
  end

  f.define :federation_failed_action do
    actions :read, :clean, :scopes => :own
  end

  f.define :saml_id_provider do
    use_traits :crud
  end

  f.define :o_auth_provider do
    actions :read, :update
  end

  f.define :iframe do
    actions :create, :update, :delete
    action :read, :scopes => :own
  end

  f.define :activity_log do
    actions :read, :delete, :list, :scopes => :own
  end

  f.define :http_caching_rule do
    use_traits :crud
  end

  f.define :cdn_location do
    actions :read, :update
  end

  f.define :vapp do
    use_traits :crud_own
    action :power, :scopes => :own
    action :convert
  end

  f.define :vcloud_catalog do
    actions :create, :update
    action :read, :scopes => [:public, :own]
    action :delete, :scopes => :own
  end

  f.define :vcloud_template do
    actions :read, :create, :delete, :deploy
  end

  f.define :vcloud_provider_vdc do
    action :read
  end

  f.define :vcloud_vapp_template do
    actions :create, :read, :delete
  end

  f.define :vcloud_media do
    actions :read, :update, :delete
  end

  f.define :availability do
  end

  f.define :zabbix do
  end

  f.define :vcloud => :vcloud do
    action :administrator_control
  end
end
