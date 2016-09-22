require 'devise_security_extension'
require 'devise_security_extension/controllers/helpers'

# Delete code here if ::DeviseSecurityExtension::VERSION >= '0.11.0'

module DeviseSecurityExtension
  module Controllers
    module Helpers
      def change_password_required_path_for(resource_or_scope = nil)
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        change_path = "#{scope}_password_expired_path"
        public_send(Devise.available_router_name).public_send(change_path)
      end
    end
  end
end
