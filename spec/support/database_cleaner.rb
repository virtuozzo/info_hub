unless ENV['SKIP_DATABASE_CLEANER']
  require_relative '../database_cleaner_configurator'

  RSpec.configure do |config|
    config.use_transactional_fixtures = false

    DatabaseCleanerConfigurator.configure(config)
  end
end
