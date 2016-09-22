require_relative 'factory/action_bucket_decorator'
require_relative 'factory/errors'

module Permissions
  module Factory
    extend self

    def build(key_identifier, action = nil, scope = nil)
      key = identifier_to_key(key_identifier)

      action_bucket, namespace = schema.fetch(key) do
        raise Errors::UnsupportedClass,
          "#{ key_identifier } has not a definition of permissions(expected #{ key })"
      end

      action_bucket.permissions(namespace, action, scope)
    end

    def define(*args, &block)
      list = args.extract_options!
      args.inject(list) { |list, key| list.merge!(key => key.to_s.pluralize.to_sym) }

      action_bucket = ActionBucketDecorator.new(block)
      list.each do |key, namespace|
        if schema.has_key?(key)
          raise Errors::DoubleDefinition,
            "#{ key } has already a definition of permissions"
        else
          schema[key] = [action_bucket, namespace]
        end
      end
    end

    def define_trait(key, &block)
      if traits.has_key?(key)
        raise Errors::DoubleTraitDefinition, "#{ key } already was defined"
      end
      traits[key] = block
    end

    def get_trait(key)
      traits.fetch(key) do
        raise Errors::UnsupportedTrait, "#{ key } was not defined"
      end
    end

    def traits
      @traits ||= {}
    end

    def schema
      @schema ||= {}
    end

    def freeze_state
      traits.freeze
      schema.freeze
    end

    private

    def identifier_to_key(identifier)
      return identifier if identifier.is_a? Symbol
      return identifier.to_sym if identifier.is_a? String

      identifier.to_s.underscore.gsub('/','_').to_sym
    end
  end
end
