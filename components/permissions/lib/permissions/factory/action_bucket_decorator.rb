require_relative 'dsl'

module Permissions
  module Factory
    class ActionBucketDecorator
      delegate :permissions, to: :action_bucket

      def initialize(block)
        @block = block || Proc.new {}
      end

      def action_bucket
        return @action_bucket if @action_bucket

        @action_bucket = Permissions::Factory::DSL.process(@block)
        remove_instance_variable(:@block)
        @action_bucket
      end
    end
  end
end
