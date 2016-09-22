require 'yaml'
require 'forwardable'

module OnApp
  class Configuration
    class BackendBase
      extend Forwardable
      include Enumerable

      delegate %i(each clear) => :hash

      def initialize(*)
        @hash = {}
      end

      def to_yaml(*)
        hash.to_yaml(line_width: -1)
      end

      def write!
        raise NotImplementedError
      end

      def write
        write!
      rescue => e
        $stderr.puts "'#{e.class}: #{e}' happened while writing configuration in #{self.class}"
      end

      def read!
        raise NotImplementedError
      end

      def read
        read!
      rescue => e
        $stderr.puts "'#{e.class}: #{e}' happened while reading configuration in #{self.class}"
      end

      def exists?
        raise NotImplementedError
      end

      def set(key, val)
        hash[key.to_s] = val
      end

      def get(key)
        hash[key.to_s]
      end

      def merge!(hash)
        hash.each { |k, v| set(k, v) }
      end

      private

      attr_reader :hash
    end
  end
end
