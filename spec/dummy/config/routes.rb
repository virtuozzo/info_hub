Rails.application.routes.draw do
  mount Core::Engine, at: '/', as: :core_engine
end
