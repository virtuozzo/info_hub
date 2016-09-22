require_relative 'authorizer/class_authorizer'
require_relative 'authorizer/object_authorizer'
require_relative 'authorizer/owner_scope_producer'

module Permissions
  module Authorizer
    extend self

    def authorized_class?(*args)
      ClassAuthorizer.authorized?(*args)
    end

    def authorized_object?(*args)
      ObjectAuthorizer.new(*args).authorized?
    end

    def owned_scope(*args)
      OwnerScopeProducer.new(*args).owned_scope
    end
  end
end
