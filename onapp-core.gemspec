$:.push File.expand_path('../lib', __FILE__)

require 'core/version'

Gem::Specification.new do |s|
  s.name        = 'onapp-core'
  s.version     = Core::VERSION
  s.authors     = ['OnApp devs']
  s.email       = ['onapp@onapp.com']
  s.summary     = 'Core part of OnApp, including controller/view layers and User model'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['README.rdoc']

  s.add_dependency 'rails'
  s.add_dependency 'devise'
  s.add_dependency 'mysql2', '~> 0.3.14'
  s.add_dependency 'yubikey_database_authenticatable'
  s.add_dependency 'devise-encryptable'
  s.add_dependency 'devise_security_extension'
  s.add_dependency 'omniauth-oauth2'
  s.add_dependency 'omniauth-saml'
  s.add_dependency 'omniauth-facebook'
  s.add_dependency 'omniauth-google-oauth2'
  s.add_dependency 'hashie'

  s.add_dependency 'haml-rails'
  s.add_dependency 'haml'
  s.add_dependency 'rabl'
  s.add_dependency 'oj'
  s.add_dependency 'simple_form'
  s.add_dependency 'simple-navigation'
  s.add_dependency 'carrierwave'
  s.add_dependency 'will_paginate'

  s.add_dependency 'onapp-utils'

  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'webrat'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'pry'
end
