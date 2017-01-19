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
  s.add_dependency 'devise',                          '3.5.10'
  s.add_dependency 'mysql2',                          '~> 0.3.14'
  s.add_dependency 'yubikey_database_authenticatable'
  s.add_dependency 'devise-encryptable',              '0.2.0'
  s.add_dependency 'devise_security_extension',       '0.10.0'
  s.add_dependency 'omniauth-oauth2'
  s.add_dependency 'omniauth-saml'
  s.add_dependency 'omniauth-facebook'
  s.add_dependency 'omniauth-google-oauth2'
  s.add_dependency 'hashie'
  s.add_dependency 'actionpack-xml_parser',           '1.0.2'
  s.add_dependency 'haml-rails',                      '0.9.0'
  s.add_dependency 'haml',                            '4.0.7'
  s.add_dependency 'rabl',                            '0.13.1'
  s.add_dependency 'oj',                              '2.18.1'
  s.add_dependency 'simple_form',                     '3.4.0'
  s.add_dependency 'simple-navigation',               '3.10.0'
  s.add_dependency 'carrierwave',                     '0.11.2'
  s.add_dependency 'will_paginate',                   '3.1.5'

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
