require_relative 'action_bucket'

module Permissions
  module Factory
    class DSL
      DEPENDENT_KEYS = %i( dependency allowed_by ).freeze
      OPTION_KEYS = %i( key scopes ).concat(DEPENDENT_KEYS).freeze

      def self.process(block)
        new.process(block)
      end

      def initialize
        @actions = {}
        @dependency_list = []
        @aliases = {}
        @strict_mode = false
      end

      def action(name, options = {})
        if @actions.has_key?(name)
          raise Permissions::Factory::Errors::DoubleActionDefinition,
            "#{ name } already was defined in this ActionBucket"
        end

        options[:dependency] ||= @dependency_list.last
        @actions[name] = options.freeze

        if block_given?
          @dependency_list << name
          yield
          @dependency_list.pop
        end
      end

      def actions(*args)
        if args.last.is_a?(Hash)
          options = args.pop
        else
          options = {}
        end
        args.each { |name| action(name, options.dup) }
      end

      def alias_actions(*list, options)
        target = options.fetch(:of) do
          raise Permissions::Factory::Errors::TargetIsNotSpecified,
            'Please provide key :of with name of action'
        end

        list.each { |alias_action| @aliases[alias_action] = target }
      end

      def use_traits(*list)
        list.each do |name|
          trait = Permissions::Factory.get_trait(name)
          instance_exec(&trait)
        end
      end

      def strict_mode!
        @strict_mode = true
      end

      def process(block)
        instance_exec(&block)
        action_bucket = Permissions::Factory::ActionBucket.new(@aliases, @strict_mode, @actions)

        sorted_actions.each do |name, options|
          check_options!(options)
          action_bucket.add(name, options)
        end

        action_bucket
      end

      private

      def check_options!(options)
        options.keys.each do |key|
          unless OPTION_KEYS.include?(key)
            raise Permissions::Factory::Errors::UnsupportedOptions,
              "`#{ key }` is not supported option"
          end
        end
      end

      def sorted_actions
        @actions.sort_by do |_, options|
          (options.key?(:allowed_by) ? 1 : 0) +
            (options.fetch(:dependency) ? 1 : 0)
        end
      end
    end
  end
end
