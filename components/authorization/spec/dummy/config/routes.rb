Rails.application.routes.draw do
  devise_for :users

  root to: 'spec#redirector'
  get 'test_redirect_back_or_default' => 'spec#test_redirect_back_or_default'
  get 'redirector' => 'spec#redirector'
  get 'denied' => 'spec#denied'
  get 'access' => 'spec#access'
  get 'required' => 'spec#required'
  get 'authorized' => 'spec#authorized'
  get 'unauthorized' => 'spec#unauthorized'
  get 'class_authorized' => 'spec#class_authorized'
  get 'class_unauthorized' => 'spec#class_unauthorized'
  get 'users/new' => 'spec#new_user_session'
end
