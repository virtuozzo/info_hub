require 'resolv'

module OnApp
  class Configuration
    autoload :FileBackend,     File.expand_path('configuration/file_backend', __dir__)
    autoload :BackendBase,     File.expand_path('configuration/backend_base', __dir__)
    autoload :ConfigAttribute, File.expand_path('configuration/config_attribute', __dir__)

    include ::ActiveModel::Validations
    extend ConfigAttribute

    DEFAULT_SYSTEM_THEME  = 'light'.freeze
    SYSTEM_THEMES         = [DEFAULT_SYSTEM_THEME, 'dark'].freeze
    AUTHENTHICATION_TOKEN = '476aede036db8e3341345e2dfb95c71caa2f2c5a'.freeze

    mattr_accessor :rails_root, :config_file_path

    config_attribute :force_saml_login_only,        setter: :boolean, inclusion: [true, false], default: false # This option is used to disable regular login for users imported (or linked with) from SAML identity providers
    config_attribute :system_email,                 presence: true, :'custom_validators/email' => true, if: :use_email_notifications, default: '' # This email will be used as Application Email
    config_attribute :system_host,                  default: 'onapp.com' # This address should be IP or Host name of this server (used in emails)
    config_attribute :system_notification,          setter: :boolean, inclusion: [true, false], default: false # Enable/Disable email system notification
    config_attribute :system_support_email,         presence: true, :'custom_validators/email' => true, if: :use_email_notifications, default: '' # This email will be used for alert emails from OnApp system
    config_attribute :system_theme,                 inclusion: SYSTEM_THEMES, default: DEFAULT_SYSTEM_THEME
    config_attribute :pagination_max_items_limit,   getter: :numerical, presence: true, numericality: true, default: 100 # Pagination
    config_attribute :app_name,                     length: { maximum: 60 }, default: 'OnApp' # Application name
    config_attribute :authentication_key,           save_to_file:false, presence: true, default: AUTHENTHICATION_TOKEN # The authentication key
    config_attribute :storage_unicast,              setter: :boolean, inclusion: [true, false], default: false # Use unicast for OnApp Storage
    config_attribute :enable_daily_storage_report,  setter: :boolean, inclusion: [true, false], default: false
    config_attribute :enable_hourly_storage_report, setter: :boolean, inclusion: [true, false], default: false
    config_attribute :private_key_path,             save_to_file: false, default: -> { OnApp::Configuration.rails_root.join('config', 'keys', 'private') } # Set the Key Pair to use for managing this system. This should be represented by a OnApp::KeyPair instance.
    config_attribute :public_key_path,              save_to_file: false, default: -> { OnApp::Configuration.rails_root.join('config', 'keys', 'public') }
    config_attribute :config_file,                  save_to_file: false, presence: true, default: -> { OnApp::Configuration.config_file_path } # Application accessor for config file

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

    # Save configuration settings to file
    # Method overwrites only a part of settings
    def save_to_file(config_file = FileBackend.new)
      config_file.read
      self.class.attributes_to_save_to_file.each { |attr| config_file.set(attr, public_send(attr)) }

      config_file.write!
    end

    def available_system_themes
      SYSTEM_THEMES
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

    private

    def use_email_notifications
      system_notification || enable_hourly_storage_report || enable_daily_storage_report
    end
  end
end
