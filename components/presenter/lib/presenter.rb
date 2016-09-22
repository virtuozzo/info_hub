require 'active_support/all'
require 'action_view'

require_relative 'presenter/helper'
require_relative 'presenter/base'

ActionView::Base.include(Presenter::Helper)
ActionController::Base.include(Presenter::Helper)
