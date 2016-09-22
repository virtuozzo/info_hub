require 'core/onapp/responders/controller_methods'
require 'core/onapp/responders/paginated_responder'

module OnApp
  class Responder < ActionController::Responder
    include OnApp::Responders::PaginatedResponder
  end
end