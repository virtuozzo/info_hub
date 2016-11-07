ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment', __FILE__)

require 'rspec/rails'
require 'pry'
require 'shoulda/matchers'
require 'webrat/core/matchers'
require 'ffaker'
require 'factory_girl_rails'

require 'onapp-core'

Dir[Core::Engine.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include Webrat::Matchers
  config.include Devise::TestHelpers, type: :controller
  config.include ActionView::TestCase::Behavior, type: :presenter

  config.use_transactional_fixtures = true
  config.disable_monkey_patching!
  config.profile_examples = nil
  config.order = :random
  config.expose_dsl_globally = true
  config.infer_spec_type_from_file_location!

  ActionView::TestCase::TestController.instance_eval do
    helper Core::Engine.routes.url_helpers
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
