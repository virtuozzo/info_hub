RSpec.configure do |config|
  config.include ActionView::TestCase::Behavior, type: :presenter
end
