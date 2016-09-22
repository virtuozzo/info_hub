require 'action_view'

module Breadcrumbs
  mattr_accessor :logger, :root_path, :show_errors, :parent_ids
  @@parent_ids = []

  autoload :CRUDCreator, File.expand_path('breadcrumbs/crud_creator', __dir__)
  autoload :Policy,      File.expand_path('breadcrumbs/policy', __dir__)
  autoload :Helpers,     File.expand_path('breadcrumbs/helpers', __dir__)
end
