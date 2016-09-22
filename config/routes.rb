Core::Engine.routes.draw do
  devise_for :users, skip: :registration, router_name: :core_engine, module: :devise, controllers: Core.devise_controllers
end
