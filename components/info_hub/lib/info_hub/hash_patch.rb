class Hash
  raise 'Hash class extensions should be removed' if ::ActiveSupport::VERSION::MAJOR >= 4

  unless {}.respond_to?(:deep_transform_keys)
    def deep_transform_keys(&block)
      result = {}

      each do |key, value|
        result[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys(&block) : value
      end

      result
    end
  end

  unless {}.respond_to?(:deep_symbolize_keys)
    def deep_symbolize_keys
      deep_transform_keys{ |key| key.to_sym rescue key }
    end
  end
end
