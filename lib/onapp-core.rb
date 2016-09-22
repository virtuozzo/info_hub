require 'rails'
require 'devise'
require 'yubikey_database_authenticatable'
require 'devise-encryptable'
require 'devise_security_extension'
require 'omniauth-saml'
require 'omniauth-facebook'
require 'omniauth-google-oauth2'

require 'mysql2'
require 'haml-rails'
require 'rabl'
require 'oj'
require 'simple_form'
require 'simple-navigation'
require 'carrierwave'
require 'will_paginate'

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
  require 'core/engine'
  require 'core/devise_security_extension/controllers/helpers'

  class << self
    def partials
      @partials ||= {}
    end

    def additional_helpers_paths
      @additional_helpers_paths ||= []
    end

    def devise_controllers
      @devise_controllers ||= { sessions: 'core/users/sessions' }
    end

    def main_navigation_group_methods
      @main_navigation_group_methods ||= [:core_main_navigation_groups]
    end
  end
end
