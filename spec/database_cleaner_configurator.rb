require 'database_cleaner'

module DatabaseCleanerConfigurator
  def self.configure(rspec_config)
    rspec_config.before(:each) do |example|
      unless example.metadata[:skip_cleaner] || example.metadata[:clean_around_all]
        # There are AR and ROM transactions therefore we can't use :transaction strategy
        # despite the fact it is faster
        DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :deletion
        DatabaseCleaner.start
      end
    end

    rspec_config.after(:each) do |example|
      unless example.metadata[:skip_cleaner] || example.metadata[:clean_around_all]
        DatabaseCleaner.clean
      end
    end

    rspec_config.prepend_before(:all, clean_around_all: true) do
      DatabaseCleaner.strategy = self.class.metadata[:js] ? :truncation : :deletion
      DatabaseCleaner.start
    end

    rspec_config.append_after(:all, clean_around_all: true) do
      DatabaseCleaner.clean
    end

    rspec_config.before(:suite) { DatabaseCleaner.clean_with :truncation }
  end
end
