require 'pry'
require 'permissions'

require 'support/object_creation_methods'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.profile_examples = nil
  config.order = :random
  config.expose_dsl_globally = true
end
