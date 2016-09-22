module Permissions
  module Factory
    class Action
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def permissions(namespace, scope)
        result = authorizers.inject([namespace.to_s]) do |result, action|
          result | action.permissions(namespace, scope)
        end

        default_permision = permission(namespace)
        result << default_permision
        result << build_permission(default_permision, scope) if scope_allowed?(scope)
        result
      end

      def permission(namespace)
        if dependency
          build_permission(dependency.permission(namespace), key)
        else
          build_permission(namespace, key)
        end
      end

      private

      def dependency
        options[:dependency]
      end

      def authorizers
        Array(options[:allowed_by]) + Array(dependency)
      end

      def key
        options[:key]
      end

      def scope_allowed?(scope)
        allowed_scopes.include? scope
      end

      def allowed_scopes
        scopes = options[:scopes]
        scopes = :own if scopes == true
        Array(scopes)
      end

      def build_permission(*list)
        list.map(&:to_s).join('.')
      end
    end
  end
end
