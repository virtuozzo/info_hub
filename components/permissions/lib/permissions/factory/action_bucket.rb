require_relative 'action'

module Permissions
  module Factory
    class ActionBucket
      attr_reader :actions

      def initialize(aliases, strict_mode)
        @actions = {}
        @aliases = aliases
        @strict_mode = strict_mode
      end

      def add(name, options)
        default_options = { key: name, scopes: false, own: false }

        action_options = options.slice(*default_options.keys).
                                 reverse_merge(default_options)
        action_options[:dependency] = find_dependency(options[:dependency])
        action_options[:allowed_by] = find_authorizers(options[:allowed_by])

        actions[name] = Permissions::Factory::Action.new(action_options)
      end

      def permissions(namespace, action_name, scope)
        return default_actions(namespace) unless action_name

        if action = find_action(action_name)
          action.permissions(namespace, scope)
        else
          Rails.logger.warn("Was used unknown action `#{ action_name }` for `#{ namespace }`")
          default_actions(namespace)
        end
      end

      def default_actions(namespace)
        strict_mode? ? [] : [namespace.to_s]
      end

      private

      def find_dependency(action_name)
        return if action_name.nil?

        actions.fetch(action_name.to_sym) do
          raise Permissions::Factory::Errors::InvalidDependency,
            "#{ action_name } is not defined in #{ namespace }"
        end
      end

      def find_authorizers(action_names)
        return if action_names.blank?
        action_names = Array(action_names)

        action_names.map { |action_name| actions.fetch(action_name.to_sym)}
      end

      def find_action(action_name)
        name = action_name.to_sym
        key = @aliases.fetch(name, name)
        actions[key]
      end

      def strict_mode?
        @strict_mode
      end
    end
  end
end
