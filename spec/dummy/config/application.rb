require File.expand_path('boot', __dir__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.encoding = 'utf-8'
    config.eager_load = false
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.active_record.raise_in_transactional_callbacks = true
  end
end

