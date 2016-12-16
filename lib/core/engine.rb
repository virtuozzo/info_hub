require 'core/restrictions' # require it to keep prefix for all tables

module Core
  class Engine < ::Rails::Engine
    # Core has to be one engine without isolate_namespace. We mean to redefine these model classes in main app
    def helpers_paths
      super.push(*::Core.additional_helpers_paths)
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match("#{root}#{File::SEPARATOR}")
        config.paths['db/migrate'].expanded.each do |path|
          app.config.paths['db/migrate'] << path
          ActiveRecord::Migrator.migrations_paths << path
        end
      end
    end

    config.generators do |g|
      g.orm             :active_record
      g.test_framework  :rspec
    end

    # https://github.com/rails-api/rails-api/issues/199
    config.middleware.use ActionDispatch::XmlParamsParser
    config.api_only = false
  end
end
