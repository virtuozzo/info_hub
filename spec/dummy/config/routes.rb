Rails.application.routes.draw do
  mount Core::Engine, at: '/', as: :onapp
end
