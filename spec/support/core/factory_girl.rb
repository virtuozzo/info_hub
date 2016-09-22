require_relative 'factory_girl_additions'

FactoryGirl.definition_file_paths = %w(../../spec/factories)

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include FactoryGirlAdditions
end