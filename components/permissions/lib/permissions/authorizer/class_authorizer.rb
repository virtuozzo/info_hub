module Permissions
  module Authorizer
    module ClassAuthorizer
      TRUE_PROC = proc { true }

      def self.authorized?(klass, user, action, options = {})
        Permissions.allow_authorization_rules.fetch(klass, TRUE_PROC).call(action) &&
          user.has_permission?(klass, action, options)
      end
    end
  end
end
