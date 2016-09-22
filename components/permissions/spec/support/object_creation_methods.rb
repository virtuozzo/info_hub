require 'active_support/core_ext/hash/reverse_merge'

module Permissions
  module ObjectCreationMethods
    def new_user(overrides = {})
      double(overrides.reverse_merge(class: user_class))
    end

    def new_image_template(overrides = {})
      double(overrides.reverse_merge(class: image_template_class))
    end

    def user_class(overrides = {})
      double('UserClass', overrides.reverse_merge(authorized_for?: false))
    end

    def image_template_class
      double('ImageTemplateClass')
    end
  end
end

RSpec.configure do |config|
  config.include(Permissions::ObjectCreationMethods)
end

