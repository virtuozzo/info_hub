require 'resolv'

module OnApp
  class Configuration
    autoload :CustomAccessors, File.expand_path('../configuration/custom_accessors', __FILE__)
    autoload :FileBackend,     File.expand_path('../configuration/file_backend', __FILE__)
    autoload :BackendBase,     File.expand_path('../configuration/backend_base', __FILE__)
    autoload :ConfigAttribute, File.expand_path('../configuration/config_attribute', __FILE__)

    include ::ActiveModel::Validations
    extend CustomAccessors
    extend ConfigAttribute

    EMAIL_DELIVERY_METHODS        = ['sendmail', 'smtp'].freeze
    SMTP_AUTHENTICATION_TYPES     = ['plain', 'login', 'cram_md5'].freeze
    DEFAULT_SYSTEM_THEME          = 'light'.freeze
    SYSTEM_THEMES                 = [DEFAULT_SYSTEM_THEME, 'dark'].freeze
    DASHBOARD_DEFAULT_HOST        = '127.0.0.1'.freeze
    DASHBOARD_POSSIBLE_PORTS      = [25, 80, 443, 5555].freeze
    DASHBOARD_DEFAULT_PORT        = '5555'.freeze
    ACCEPT                        = 'ACCEPT'.freeze
    FIREWALL_POLICIES             = [ACCEPT, 'DROP'.freeze].freeze
    LOG_LEVELS                    = ['debug', 'info', 'warn', 'error', 'fatal'].freeze
    SNMP_STATS_PROTOCOLS          = ['udp', 'tcp'].freeze
    SNMP_STATS_PROTOCOL_DEFAULT   = 'udp'.freeze
    MONITIS_APIKEY                = '4JIA5DJUM9O01HJ550B88V73GR'.freeze
    MONITIS_SECRETKEY             = '4UO8AO1JU8GO08F2LLMJBNJCAM'.freeze
    AUTHENTHICATION_TOKEN         = '476aede036db8e3341345e2dfb95c71caa2f2c5a'.freeze
    AUTH_TOKEN                    = '_kAkotafjty7mbNdt85gr7r6MLYi8maRmskNqdcHXyzAEVg12qwcCUg3XNzzBxV9oo7ZgTmtEM-yLdWXCQk7dycf5zgwpmTrGTuesBzmS7V-H8ey2go7te1d9ypunbHp'.freeze
    ISO_PATH                      = '/data'.freeze
    IP_ADDRESS                    = '192.168.1.1'.freeze
    ONAPP_NAME                    = 'onapp'.freeze
    GRAPH_FREQUENCIES             = [['hourly', 4000], ['daily', 100000], ['weekly', 800000], ['monthly', Utils::Numeric.to_number(3.2, :M)], ['yearly', Utils::Numeric.to_number(40, :M)]].freeze
    BOOLEAN_SETTER                = :boolean
    NUMERICAL_GETTER              = :numerical

    config_attribute :ssl_pem_path
    config_attribute :use_yubikey_login,                              inclusion: [true, false], default: false
    config_attribute :yubikey_api_key,                                presence: { if: :use_yubikey_login }
    config_attribute :yubikey_api_id,                                 presence: { if: :use_yubikey_login }
    config_attribute :rabbitmq_host
    config_attribute :rabbitmq_port,                                  getter: :numerical, inclusion: { in: 1..65535 }, default: 5672
    config_attribute :rabbitmq_vhost
    config_attribute :rabbitmq_login
    config_attribute :rabbitmq_password,                              setter: false
    config_attribute :allow_incremental_backups,                      setter: :boolean, inclusion: [true, false], default: false # Option for allow or not incremental backups
    config_attribute :use_ssh_file_transfer,                          setter: :boolean, inclusion: [true, false], default: false # Should we use SSH to connect to backups and templates?
    config_attribute :ssh_file_transfer_server,                       presence: { if: :required_ssh_file_transfer }, default: '127.0.0.1' # SSH connection options
    config_attribute :ssh_file_transfer_user,                         presence: { if: :required_ssh_file_transfer }, default: 'root'
    config_attribute :ssh_file_transfer_options,                      presence: { if: :required_ssh_file_transfer }, default: '-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o PasswordAuthentication=no'
    config_attribute :ssh_port,                                       getter: :numerical, inclusion: { in: 1..65535 }, default: 22
    config_attribute :template_path,                                  default: '/onapp/templates', presence: true # The location of image templates
    config_attribute :backups_path,                                   default: '/onapp/backups', presence: true# The location of backups
    config_attribute :data_path,                                      default: '/onapp/data', presence: true# The location of application data
    config_attribute :update_server_url,                              :'custom_validators/url' => true, presence: true, default: 'http://templates-manager.onapp.com' # The URL of remote update server
    config_attribute :delete_template_source_after_install,           setter: :boolean, inclusion: [true, false], default: false # Delete downloaded template source archive from :template_path Should be false if :template_path is mounted or shared folder
    config_attribute :license_key,                                    presence: true, default: '' # The license key
    config_attribute :force_saml_login_only,                          setter: :boolean, inclusion: [true, false], default: false # This option is used to disable regular login for users imported (or linked with) from SAML identity providers
    config_attribute :generate_comment,                               presence: true, default: "# Automatically generated by OnApp (%s)" # The comment to insert into files generated by OnApp
    config_attribute :simultaneous_backups,                           getter: :numerical, presence: true, numericality: true, default: 2 # The number of backups which can run at the same time
    config_attribute :simultaneous_backups_per_datastore,             getter: :numerical, numericality: { greater_than: 0 }, default: 2 # The number of backups which can run at the same time per DataStore
    config_attribute :simultaneous_backups_per_hypervisor,            getter: :numerical, numericality: { greater_than: 0 }, default: 1# The number of backups which can run at the same time per Hypervisor
    config_attribute :simultaneous_transactions,                      getter: :numerical, presence: true, numericality: true, default: 3 # The number of transactions runers which can run at the same time
    config_attribute :simultaneous_storage_resync_transactions,       presence: true, numericality: true, default: 3 # Number of storage resync (repair/rebalance) transactions that can be run at the same time
    config_attribute :guest_wait_time_before_destroy,                 getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 30, less_than_or_equal_to: 600, message: 'Please enter a number between 30 and 600' }, default: 60 # Timeout in seconds before turning off the power supply guest
    config_attribute :remote_access_session_start_port,               getter: :numerical, presence: true, numericality: true, default: 30000 # Virtual machine console port number from
    config_attribute :remote_access_session_last_port,                getter: :numerical, presence: true, numericality: true, default: 30099 # Virtual machine console port number to
    config_attribute :system_email,                                   presence: true, :'custom_validators/email' => true, if: :use_email_notifications, default: '' # This email will be used as Application Email
    config_attribute :ajax_power_update_time,                         getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 1000, less_than_or_equal_to: 10000, message: 'Please enter a time between 1,000 and 10,000 (ms)' }, default: 8000 # VM Power status updating time in millisecond shuld be included in 1-10 sec
    config_attribute :ajax_pagination_update_time,                    getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 1000, less_than_or_equal_to: 10000, message: 'Please enter a time between 1,000 and 10,000 (ms)' }, default: 9000 # Updates time in millisecond for pagination blocks
    config_attribute :ajax_log_update_interval,                       presence: true, numericality: { greater_than_or_equal_to: 1000, less_than_or_equal_to: 10000, message: 'Please enter a time between 1,000 and 10,000 (ms)' }, default: 5000 # log output automatic refresh interval
    config_attribute :hypervisor_live_times,                          getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 100, message: 'Please enter a number between 1 and 100' }, default: 12 # Number of times until the hypervisor is a online
    config_attribute :enable_huge_pages,                              setter: :boolean, inclusion: [true, false], default: false # Huge pages supported by KVM Centod 6. When this option enabled we will add huge part to Guest config
    config_attribute :system_host,                                    default: 'onapp.com' # This address should be IP or Host name of this server (used in emails)
    config_attribute :system_notification,                            setter: :boolean, inclusion: [true, false], default: false # Enable/Disable email system notification
    config_attribute :system_support_email,                           presence: true, :'custom_validators/email' => true, if: :use_email_notifications, default: '' # This email will be used for alert emails from OnApp system
    config_attribute :recovery_templates_path,                        presence: true, default: '/onapp/tools/recovery' # The location of recovery image templates
    config_attribute :iso_path_on_cp,                                 presence: true, default: ISO_PATH # The location of ISOs for mounting on VMs
    config_attribute :iso_path_on_hv,                                 presence: true, default: ISO_PATH
    config_attribute :remove_backups_on_destroy_vm,                   setter: :boolean, inclusion: [true, false], default: true # If this mode is enabled, backups should be destroyed
    config_attribute :disable_hypervisor_failover,                    setter: :boolean, inclusion: [true, false], default: false # Disable HV failover
    config_attribute :ips_allowed_for_login,                          default: '' # IPs allowed to see login page. should be an empty to allow all or string with IPs comma-separated, like '1.1.1.1, 2.2.2.2, 2.3.3.3'
    config_attribute :monitis_path,                                   default: '/usr/local/monitis' # Monitis client path (on Guest)
    config_attribute :monitis_account,                                default: 'monitis@onapp.com' # Monitis email
    config_attribute :monitis_apikey,                                 default: MONITIS_APIKEY # Monitis apikey
    config_attribute :locales,                                        default: ['en'] # Available application locales
    config_attribute :system_theme,                                   inclusion: SYSTEM_THEMES, default: DEFAULT_SYSTEM_THEME
    config_attribute :max_memory_ratio,                               getter: :numerical, presence: true, numericality: true, default: 16 # Guest memory coefficient, how we can increase memory. Default length ported from 2.3.2 version
    config_attribute :remove_old_root_passwords,                      inclusion: [true, false], default: false # Remove VM root password if wasn't changed for more than hour
    config_attribute :pagination_max_items_limit,                     getter: :numerical, presence: true, numericality: true, default: 100 # Pagination
    config_attribute :default_image_template,                         getter: :numerical, numericality: { allow_nil: true } # Default new VM options
    config_attribute :service_account_name,                           default: ONAPP_NAME
    config_attribute :default_firewall_policy,                        inclusion: FIREWALL_POLICIES, default: ACCEPT # Default firewall policy
    config_attribute :app_name,                                       length: { maximum: 60 }, default: 'OnApp' # Application name
    config_attribute :show_ip_address_selection_for_new_vm,           setter: :boolean, inclusion: [true, false], default: false # if set to true, user can select a particular IP address from the list of available addresses when they create new VM
    config_attribute :backup_taker_delay,                             getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 600 }, default: 300 # Number of seconds before execute background task again
    config_attribute :billing_stat_updater_delay,                     getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 100 }, default: 5
    config_attribute :cluster_monitor_delay,                          getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 100 }, default: 5
    config_attribute :hypervisor_monitor_delay,                       getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 100 }, default: 5
    config_attribute :cdn_sync_delay,                                 getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 300, less_than_or_equal_to: 6000 }, default: 1200
    config_attribute :schedule_runner_delay,                          getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 900 }, default: 60
    config_attribute :transaction_runner_delay,                       getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 600 }, default: 300
    config_attribute :billing_transaction_runner_delay,               getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 3600 }, default: 3600
    config_attribute :zombie_transaction_time,                        getter: :numerical, numericality: { greater_than: 0, message: 'Please enter the amount of the minutes not to consider transaction a zombie' }, default: 20
    config_attribute :zombie_disk_space_updater_delay,                getter: :numerical, numericality: { greater_than: 0 }, default: 300 # 5 mins
    config_attribute :run_recipe_on_vs_sleep_seconds,                 getter: :numerical, numericality: { greater_than: 0, message: 'Please enter the amount of the seconds to sleep before running recipe on a Virtual Server' }, default: 10
    config_attribute :dns_enabled,                                    setter: :boolean, inclusion: [true, false], default: false
    config_attribute :enabled_libvirt_anti_spoofing,                  setter: :boolean, inclusion: [true, false], default: false
    config_attribute :allow_start_vms_with_one_ip,                    setter: :boolean, inclusion: [true, false], default: true
    config_attribute :ip_range_limit,                                 getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 2, only_integer: true }, default: 1024 # The maximum number of IP Addresses that can be created in one step
    config_attribute :allow_initial_root_password_encryption,         setter: :boolean, inclusion: [true, false], default: false
    config_attribute :wipe_out_disk_on_destroy,                       setter: :boolean, inclusion: [true, false], default: false # Enable/Disable WipeOut or Format disk on destroy
    config_attribute :partition_align_offset,                         numericality: true, default: 2048
    config_attribute :password_enforce_complexity,                    setter: :boolean, inclusion: [true, false], default: true # Password complexity configuration
    config_attribute :password_minimum_length,                        getter: :numerical, numericality: { only_integer: true, greater_than_or_equal_to: 6, less_than_or_equal_to: 99 }, default: 12
    config_attribute :password_upper_lowercase,                       setter: :boolean, inclusion: [true, false], default: true
    config_attribute :password_letters_numbers,                       setter: :boolean, inclusion: [true, false], default: true
    config_attribute :password_symbols,                               setter: :boolean, inclusion: [true, false], default: true
    config_attribute :password_force_unique,                          setter: :boolean, inclusion: [true, false], default: true
    config_attribute :password_lockout_attempts,                      getter: :numerical, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 9 }, default: 3
    config_attribute :password_expiry,                                getter: :numerical, inclusion: [0, 1, 3, 6, 12], default: 1
    config_attribute :password_history_length,                        getter: :numerical, numericality: { only_integer: true }, default: 12
    config_attribute :cloud_boot_enabled,                             setter: :boolean, inclusion: [true, false], default: false
    config_attribute :nfs_root_ip,                                    presence: true, format: { with: Resolv::IPv4::Regex }, default: IP_ADDRESS # Static Config target
    config_attribute :cloud_boot_target,                              presence: true, format: { with: Resolv::IPv4::Regex }, default: IP_ADDRESS # CP Cloudboot target
    config_attribute :storage_enabled,                                setter: :boolean, inclusion: [true, false], default: false # OnApp Storage enabled
    config_attribute :prefer_local_reads,                             setter: :boolean, inclusion: [true, false], default: false # OnApp Storage should use a local read path
    config_attribute :allow_hypervisor_password_encryption,           setter: :boolean, inclusion: [true, false], default: false # Allow password encryption for VMware HVs
    config_attribute :archive_stats_period,                           getter: :numerical, numericality: true, default: 2
    config_attribute :instant_stats_period,                           getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 1, only_integer: true }, default: 1
    config_attribute :is_archive_stats_enabled,                       setter: :boolean, inclusion: [true, false], default: false
    config_attribute :system_alert_reminder_period,                   getter: :numerical, numericality: { greater_than: 0 }, default: 60
    config_attribute :wrong_activated_logical_volume_alerts,          setter: :boolean, inclusion: [true, false], default: false
    config_attribute :wrong_activated_logical_volume_minutes,         getter: :numerical, numericality: { greater_than: 0 }, default: 60
    config_attribute :use_html5_vnc_console,                          setter: :boolean, inclusion: [true, false], default: false
    config_attribute :storage_endpoint_override                       # Override Storage Endpoint with a custom IP
    config_attribute :max_network_interface_port_speed,               getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 100000, message: 'Please enter a port speed between 1 and 100,000 (Mbps)' }, default: 1000 # Network interface port speed max value
    config_attribute :url_for_custom_tools,                           default: ''
    config_attribute :backup_convert_coefficient,                     getter: false, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 2 }, default: 1.1
    config_attribute :rsync_option_xattrs,                            setter: :boolean, inclusion: [true, false], default: false # Rsync Options
    config_attribute :rsync_option_acls,                              setter: :boolean, inclusion: [true, false], default: true
    config_attribute :simultaneous_backups_per_backup_server,         getter: :numerical, numericality: { greater_than: 0 }, default: 2
    config_attribute :email_delivery_method,                          inclusion: EMAIL_DELIVERY_METHODS, default: 'sendmail'
    config_attribute :smtp_address,                                   default: 'localhost'
    config_attribute :smtp_port,                                      getter: :numerical, default: 25
    config_attribute :smtp_domain,                                    default: 'localhost.localdomain'
    config_attribute :smtp_username
    config_attribute :smtp_password
    config_attribute :smtp_authentication,                            inclusion: SMTP_AUTHENTICATION_TYPES
    config_attribute :smtp_enable_starttls_auto,                      setter: :boolean, inclusion: [true, false], default: true
    config_attribute :enable_hourly_storage_report,                   setter: :boolean, inclusion: [true, false], default: false
    config_attribute :enable_daily_storage_report,                    setter: :boolean, inclusion: [true, false], default: false
    config_attribute :storage_unicast,                                setter: :boolean, inclusion: [true, false], default: false # Use unicast for OnApp Storage
    config_attribute :snmptrap_addresses
    config_attribute :snmptrap_port,                                  getter: :numerical, numericality: { greater_than: 1024 }, default: 3162
    config_attribute :infiniband_cloud_boot_enabled,                  setter: :boolean, inclusion: [true, false], default: false
    config_attribute :qemu_detach_device_delay,                       getter: :numerical, default: 2
    config_attribute :qemu_attach_device_delay,                       getter: :numerical, default: 10
    config_attribute :tc_latency,                                     getter: :numerical, numericality: { greater_than: 0 }, default: 50 # Traffic control
    config_attribute :tc_burst,                                       getter: :numerical, numericality: { greater_than: 0 }, default: 1
    config_attribute :tc_mtu,                                         getter: :numerical, numericality: { greater_than: 0 }, default: 33000
    config_attribute :ha_enabled,                                     setter: :boolean, inclusion: [true, false], default: false
    config_attribute :dashboard_api_access_token                      # Access token for Dashboard API
    config_attribute :allow_connect_aws,                              setter: :boolean, inclusion: [true, false], default: false
    config_attribute :federation_trusts_only_private,                 setter: :boolean, inclusion: [true, false], default: false
    config_attribute :maximum_pending_tasks,                          getter: :numerical, numericality: { greater_than: 0 }, default: 20
    config_attribute :max_upload_size,                                getter: :numerical, presence: true, numericality: true, default: 1073741824 # Max upload size for web server
    config_attribute :transaction_standby_period,                     getter: :numerical, numericality: { greater_than_or_equal_to: 15, less_than_or_equal_to: 1800 }, default: 30  # Amount of time, which transaction spends in Stand-by queue (to decrease database and redis load (CPU, I/O)). Range: 15sec - 30min
    config_attribute :log_cleanup_period,                             numericality: { allow_blank: true, greater_than_or_equal_to: 0 }, default: 90 #days
    config_attribute :log_cleanup_enabled,                            setter: :boolean, inclusion: [true, false], default: false
    config_attribute :log_level,                                      inclusion: LOG_LEVELS, default: 'info'
    config_attribute :cdn_max_results_per_get_page,                   getter: :numerical, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 3000 }, default: 500 # Amount of instances per page, which can be retrieved via API from Aflexi. Range: 1 - 3000 instances. Tests: 500 entities wil be extracted from Aflexi for ~16 sec. 1000 ~ 18-25 sec. 1500 ~ 27-40 sec
    config_attribute :instance_packages_threshold_num,                numericality: { greater_than_or_equal_to: 1 }, default: 3 # Instance Packages count for horizontal view
    config_attribute :amount_of_service_instances,                    getter: :numerical, numericality: { greater_than: 0 }, default: 2
    config_attribute :graceful_stop_timeout,                          getter: :numerical, numericality: { greater_than: 0 }, default: 60 * 5 # 5 minutes
    config_attribute :allow_to_collect_errors,                        setter: :boolean, inclusion: [true, false], default: false # Error collector options
    config_attribute :password_protection_for_deleting,               setter: :boolean, inclusion: [true, false], default: false
    config_attribute :draas_enabled,                                  setter: :boolean, inclusion: [true, false], default: false
    config_attribute :zabbix_host,                                    default: 'localhost'
    config_attribute :zabbix_url,                                     default: '/zabbix'
    config_attribute :zabbix_user,                                    default: 'Admin'
    config_attribute :zabbix_password,                                default: 'zabbix'
    config_attribute :ping_vms_before_init_failover,                  setter: :boolean, inclusion: [true, false], default: true # Ping VMs before initiating Failover
    config_attribute :vcloud_stats_level1_period,                     default: 60 # vCloud default values
    config_attribute :vcloud_stats_level2_period,                     default: 180
    config_attribute :vcloud_stats_usage_interval,                    default: 20
    config_attribute :vcloud_prevent_idle_session_timeout,            default: 600
    config_attribute :google_map_token,                               default: ''
    config_attribute :cloud_boot_domain_name_servers,                 presence: true, default: IP_ADDRESS # Cloud boot domain name servers
    config_attribute :enforce_redundancy,                             setter: :boolean, inclusion: [true, false], default: true # Enforce datastore redundancy across HVs for OnApp Storage

    config_attribute :load_paths,                                     save_to_file:false # Which directories should be included in the load path?
    config_attribute :log_path,                                       save_to_file:false, default: -> { Configuration.rails_root.join('log', 'onapp.log') } # The path to use for logging the OnApp output (used when the default logger is invoked)
    config_attribute :background_process_log_path,                    save_to_file:false, default: -> { Configuration.rails_root.join('log') } # The path to use for logging all output from OnApp background processes
    config_attribute :background_process_pid_path,                    save_to_file:false, default: -> { Configuration.rails_root.join('tmp', 'pids') } # The path to use for storing PIDs from OnApp background processes
    config_attribute :private_key_path,                               save_to_file:false, default: -> { Configuration.rails_root.join('config', 'keys', 'private') } # Set the Key Pair to use for managing this system. This should be represented by a OnApp::KeyPair instance.
    config_attribute :public_key_path,                                save_to_file:false, default: -> { Configuration.rails_root.join('config', 'keys', 'private') }
    config_attribute :currencies,                                     save_to_file:false # Currencies for billing
    config_attribute :database_backups_path,                          save_to_file:false, presence: true, default: '/onapp/database_backups' # The location of database backups
    config_attribute :update_server_api_version,                      save_to_file:false, numericality: true, default: 3
    config_attribute :instance_package_min_disk_size,                 save_to_file:false, default: 6
    config_attribute :instance_package_max_disk_size,                 save_to_file:false, default: 100
    config_attribute :instance_package_max_memory,                    save_to_file:false, default: 16384
    config_attribute :instance_package_min_bandwidth,                 save_to_file:false, default: 1
    config_attribute :graph_frequencies,                              save_to_file:false, presence: true, default: GRAPH_FREQUENCIES # The names and frequencies for graph generation
    config_attribute :authentication_key,                             save_to_file:false, presence: true, default: AUTHENTHICATION_TOKEN # The authentication key
    config_attribute :schedule_failure_count,                         save_to_file:false, presence: true, default: 100 # The number of failed running for schedule
    config_attribute :ajax_as_status_interval,                        save_to_file:false, getter: :numerical, presence: true, numericality: { greater_than_or_equal_to: 10000, less_than_or_equal_to: 60000, message: 'Please enter a time between 10,000 and 60,000 (ms)' }, default: 20000
    config_attribute :config_file,                                    save_to_file:false, presence: true, default: -> { Configuration.config_file_path } # Application accessor for config file
    config_attribute :enable_ipv6,                                    save_to_file:false, setter: :boolean, inclusion: [true, false], default: true # Enable IPv6
    config_attribute :kms_server_host,                                save_to_file:false, default: '' # KMS server
    config_attribute :kms_server_port,                                save_to_file:false, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 65535, message: 'Please enter a number between 1 and 65536' }, default: 1
    config_attribute :monitis_secret_key,                             save_to_file:false, default: MONITIS_SECRETKEY # Monitis secret_key
    config_attribute :dashboard_host,                                 save_to_file:false, default: DASHBOARD_DEFAULT_HOST
    config_attribute :dashboard_port,                                 save_to_file:false, default: DASHBOARD_DEFAULT_PORT
    config_attribute :same_autoscaleout_nodes_virtualization_system,  save_to_file:false, setter: :boolean, inclusion: [true, false], default: true # Esure autoscale nodes and balancer use same virtualization system
    config_attribute :snmp_stats_protocol,                            save_to_file:false, inclusion: SNMP_STATS_PROTOCOLS, default: SNMP_STATS_PROTOCOL_DEFAULT # SNMP default values
    config_attribute :server_community,                               save_to_file:false, default: ONAPP_NAME
    config_attribute :snmp_timeout,                                   save_to_file:false, default: 2
    config_attribute :snmp_connect_retries,                           save_to_file:false, default: 3
    config_attribute :snmp_max_recv_bytes,                            save_to_file:false, default: 100000
    config_attribute :snmp_stats_level1_period,                       save_to_file:false, default: 10
    config_attribute :snmp_stats_level2_period,                       save_to_file:false, default: 60
    config_attribute :snmp_stats_level3_period,                       save_to_file:false, default: 120
    config_attribute :vmware_stats_level1_period,                     save_to_file:false, default: 60 # VMWare default values
    config_attribute :vmware_stats_level2_period,                     save_to_file:false, default: 180
    config_attribute :vmware_stats_usage_interval,                    save_to_file:false, default: 20
    config_attribute :solidfire_stats_usage_interval,                 save_to_file:false, numericality: { greater_than: 5 }, default: 120 # Solidfire stats
    config_attribute :error_aggregator_url,                           save_to_file:false, default: 'https://error-reports.onapp.com/api/v1/report'
    config_attribute :auth_email,                                     save_to_file:false, default: 'crash.reports@onapp.com'
    config_attribute :auth_token,                                     save_to_file:false, default: AUTH_TOKEN
    config_attribute :cdn_api_url,                                    save_to_file:false, getter: false # CDN API url
    config_attribute :cdn_api_username,                               save_to_file:false, getter: false # CDN OPERATOR username
    config_attribute :cdn_api_password,                               save_to_file:false, getter: false # CDN OPERATOR password

    mattr_accessor :rails_root, :config_file_path

    def initialize
      self.class.defaults.each do |key, value|
        value = value.call if value.is_a?(Proc)

        public_send("#{ key }=", value)
      end

      @storage_unicast_changed = false
    end

    def to_xml(options = {})
      options[:root] ||= :settings
      options[:dasherize] ||= false

      hash = serialized_values
      hash.select! { |attr| Array(options[:only]).include?(attr) } if options.has_key?(:only)
      hash.to_xml(options)
    end

    def to_json(options = {})
      json = serialized_values.to_json(options)
      json = %({"settings":#{json}}) if ActiveRecord::Base.include_root_in_json
      json
    end

    def serialized_values
      self.class.attributes_to_save_to_file.inject({}) { |result, attr| result.merge!(attr => public_send(attr)) }
    end

    def use_html5_vnc_console
      @use_html5_vnc_console && OnApp.centos.version > 5
    end
    alias_method :use_html5_vnc_console?, :use_html5_vnc_console

    def update_attributes(attributes = {})
      @storage_unicast_changed = false

      attributes.symbolize_keys.slice(*self.class.attributes_to_save_to_file).each do |attr, value|
        public_send("#{attr}=", value)
      end

      valid?(:update)
    end

    def load_from_file(config_file = FileBackend.new)
      return false unless config_file.exists? && config_file.read

      config_file.each do |k, v|
        public_send("#{k}=", v) rescue $stderr.puts("WARNING: OnApp configuration key [#{k}] is invalid, please remove this from [#{config_file}] config file!")
      end

      @storage_unicast_changed = false

      true
    end

    def default_firewall_policy
      @default_firewall_policy.to_s.presence || ACCEPT
    end

    def currencies=(value)
      @currencies = []
    end

    def available_system_themes
      SYSTEM_THEMES
    end

    def password_minimum_length=(value)
      @password_minimum_length = value
    end

    # HACK: When submitting form with an empty field (password fields
    # are always emppty in editing forms) this field will be updated
    # to an empty string.
    def rabbitmq_password=(value)
      @rabbitmq_password = value unless value.blank?
    end

    def backup_convert_coefficient
      @backup_convert_coefficient.to_f
    end

    def password_minimum_length?
      password_minimum_length > 0
    end

    def password_upper_lowercase?
      check_for_passwd_complexity(@password_upper_lowercase)
    end

    def password_letters_numbers?
      check_for_passwd_complexity(@password_letters_numbers)
    end

    def password_symbols?
      check_for_passwd_complexity(@password_symbols)
    end

    def password_force_unique?
      check_for_passwd_complexity(@password_force_unique)
    end

    def password_expiry?
      @password_expiry > 0
    end

    def update_server_url=(value)
      @update_server_url = value.starts_with?('http') || value.blank? ? value : "http://#{value}"
    end

    def storage_unicast=(value)
      value = Utils::AR.value_to_boolean(value)

      @storage_unicast_changed = @storage_unicast != value
      @storage_unicast = value
    end

    # Save configuration settings to file
    # Method overwrites only a part of settings
    def save_to_file(config_file = FileBackend.new)
      config_file.read
      self.class.attributes_to_save_to_file.each { |attr| config_file.set(attr, public_send(attr)) }

      config_file.write!
    end

    ## Validate environment to ensure everything is setup correctly.
    def validate_environment!
      errors = []
      ## Various checks...
      errors << "OnApp public key does not exist at '#{public_key_path}'" unless File.exist?(public_key_path)
      errors << "OnApp private key does not exist at '#{private_key_path}'" unless File.exist?(private_key_path)
      ## Return all errors to stderr and exit with code 1. All errors here are 'mission critical'
      unless errors.empty?
        errors.each { |e| $stderr.puts "CRITICAL ERROR: #{e}" }
        Process.exit(1)
      end
      $stderr.puts("WARNING: OnApp configuration file #{config_file} not found! Please go to http://<CP_IP_ADDRESS>/settings/edit and save configuration to create this with the required settings.") unless File.exist?(config_file)
    end

    def default?(key)
      public_send(key) == self.class.defaults[key]
    end

    def snmptrap_addresses_array
      return [] unless snmptrap_addresses

      snmptrap_addresses.gsub(/\s+/, '').split(',').delete_if(&:blank?)
    end

    def log_level_int
      LOG_LEVELS.index(log_level) || 0
    end

    private

    def required_ssh_file_transfer
      use_ssh_file_transfer
    end

    def check_for_passwd_complexity(attr)
      @password_enforce_complexity ? attr : false
    end

    def use_email_notifications
      system_notification || enable_hourly_storage_report || enable_daily_storage_report
    end
  end
end
