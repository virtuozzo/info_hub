require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'

Bundler.require(*Rails.groups)
require 'filterable'

module Dummy
  class Application < Rails::Application
    config.encoding = 'utf-8'

    config.filter_parameters += [:password]

    config.active_support.escape_html_entities_in_json = true

    config.active_record.whitelist_attributes = true

    config.assets.enabled = true

    config.assets.version = '1.0'
  end
end

