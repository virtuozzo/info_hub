require 'rails'
require 'devise'
require 'yubikey_database_authenticatable'
require 'devise-encryptable'
require 'devise_security_extension'
require 'omniauth-saml'
require 'omniauth-facebook'
require 'omniauth-google-oauth2'
require 'actionpack/xml_parser'

require 'mysql2'
require 'haml-rails'
require 'rabl'
require 'oj'
require 'simple_form'
require 'simple-navigation'
require 'carrierwave'
require 'will_paginate'
require 'responders'

require 'onapp-utils'

# require inside components as a libs for not to require them outside
# https://github.com/bundler/bundler/issues/4866
# but leave them as standalone libraries
require_relative '../components/authorization/lib/authorization'
require_relative '../components/breadcrumbs/lib/breadcrumbs'
require_relative '../components/custom_validators/lib/custom_validators'
require_relative '../components/filterable/lib/filterable'
require_relative '../components/info_hub/lib/info_hub'
require_relative '../components/onapp-configuration/lib/onapp-configuration'
require_relative '../components/permissions/lib/permissions'
require_relative '../components/presenter/lib/presenter'

module Core
  require_relative 'core/engine'
  require_relative 'core/devise_security_extension/controllers/helpers'
  require_relative '../app/models/onapp/models/base'

  mattr_reader :partials
  @@partials = {}

  mattr_reader :additional_helpers_paths
  @@additional_helpers_paths = []

  mattr_reader :devise_controllers
  @@devise_controllers = { sessions: 'core/users/sessions' }

  mattr_reader :main_navigation_group_methods
  @@main_navigation_group_methods = [:core_main_navigation_groups]

  mattr_reader :concerns
  @@concerns = {}

  mattr_reader :extensions
  @@extensions = {}

  def self.add_concerns(params = {})
    params.each_pair do |key, array|
      concerns[key] ||= []
      concerns[key].concat(array)
    end
  end

  def self.add_extensions(params = {})
    params.each_pair do |key, extension|
      extensions[key] ||= []
      extensions[key] << extension
    end
  end

  def self.constantized_extensions(key)
    extensions.fetch(key, []).map(&:constantize)
  end
end
