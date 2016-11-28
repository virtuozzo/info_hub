unless ENV['SKIP_DATABASE_CLEANER']
  require 'database_cleaner'

  RSpec.configure do |config|
    config.before(:suite, database: true) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.after(:each, database: true) do |example|
      DatabaseCleaner.clean
    end
  end
end
