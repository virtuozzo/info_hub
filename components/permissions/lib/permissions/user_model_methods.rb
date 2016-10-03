require_relative 'factory'

module Permissions
  module UserModelMethods
    def self.attached_to(relation_name)
      # def permission_identifiers
      define_method :permission_identifiers do
        @permission_identifiers ||= public_send(relation_name).pluck(:identifier)
      end

      self
    end

    # can be called with one action and scope:
    # user.has_permission?(ImageTemplate, :read, scope: :own)
    def has_permission?(resource, action = nil, options = {})
      Factory.build(resource, action, options.fetch(:scope, :own)).any? do |identifier|
        identifier.in? permission_identifiers
      end
    end

    # can be called with many actions and scopes:
    # user.has_any_permission?(ImageTemplate, :read, :update,
    #                          scopes: [:user, :own, :public])
    def has_any_permission?(resource, *actions)
      return true if has_permission?(resource)

      scopes = [:all].concat(Array(actions.extract_options![:scopes])).uniq

      actions.each do |action|
        return true if has_permission?(resource, action)

        scopes.each do |scope|
          return true if has_permission?(resource, action, scope: scope)
        end
      end

      false
    end
  end
end
