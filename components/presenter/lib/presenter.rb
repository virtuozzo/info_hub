require 'active_support/all'
require 'action_view'

require_relative 'presenter/view_helper'
require_relative 'presenter/controller_helper'
require_relative 'presenter/base'

ActionView::Base.include(Presenter::ViewHelper)
ActionController::Base.include(Presenter::ControllerHelper)
