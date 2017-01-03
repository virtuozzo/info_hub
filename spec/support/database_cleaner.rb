unless ENV['SKIP_DATABASE_CLEANER']
  require 'database_cleaner'

  def disable_referential_integrity
    Sequel::DATABASES.first.run('SET FOREIGN_KEY_CHECKS=0;')
    yield
    Sequel::DATABASES.first.run('SET FOREIGN_KEY_CHECKS=1;')
  end

  RSpec.configure do |config|
    config.use_transactional_fixtures = false

    config.before(:suite) do
      DatabaseCleaner[:active_record].strategy = :transaction
      DatabaseCleaner[:sequel].strategy = :transaction

      disable_referential_integrity do
        DatabaseCleaner.clean_with :truncation
      end
    end

    config.before(:each) do |example|
      DatabaseCleaner[:active_record].strategy = example.metadata[:js] ? :deletion : :transaction
      DatabaseCleaner.start unless example.metadata[:skip_cleaner]
    end

    config.after(:each) do |example|
      DatabaseCleaner.clean unless example.metadata[:skip_cleaner]
    end

    config.before(:all, truncate_before_all: true) do
      disable_referential_integrity do
        DatabaseCleaner.clean_with :truncation
      end
    end
  end
end
