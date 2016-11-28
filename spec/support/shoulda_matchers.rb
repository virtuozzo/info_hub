require 'shoulda/matchers'

if Shoulda::Matchers.respond_to?(:configure)
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
end

RSpec.configure do |config|
  config.include Shoulda::Matchers::ActionController, type: :routing
end
