unless ENV['SKIP_DATABASE_CLEANER']
  require 'database_cleaner'

  RSpec.configure do |config|
    config.use_transactional_fixtures = false

    config.before(:each) do |example|
      # There are AR and ROM transactions therefore we can't use :transaction strategy
      # despite the fact it is faster
      DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :deletion
      DatabaseCleaner.start unless example.metadata[:skip_cleaner]
    end

    config.after(:each) { |example| DatabaseCleaner.clean unless example.metadata[:skip_cleaner] }
    config.before(:suite) { DatabaseCleaner.clean_with :truncation }
  end
end
