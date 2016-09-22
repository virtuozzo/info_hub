require_relative 'backend_base'

module OnApp
  class Configuration
    class FileBackend < BackendBase
      attr_reader :path

      def initialize(path = nil)
        @path = path || Configuration.config_file_path

        super
      end

      def write!
        File.write(path, to_yaml) if @hash.keys.any?

        true
      end

      def read!
        @hash.merge!(YAML.load_file(path) || {})

        true
      end

      def exists?
        File.file?(path)
      end
    end
  end
end
