$:.push File.expand_path('../lib', __FILE__)

require 'onapp/configuration/version'

Gem::Specification.new do |s|
  s.name        = 'onapp-configuration'
  s.version     = OnApp::Configuration::VERSION
  s.authors     = ['OnApp devs']
  s.email       = %w( onapp@onapp.com )
  s.summary     = 'OnApp Configuration'
  s.description = 'Gem to define a configuration set for the OnApp library.'

  s.files = Dir['{app,config,db,lib}/**/*'] + %w( README.md )

  s.add_dependency 'activerecord', '3.2.22'
  s.add_dependency 'onapp-utils', '~>5.0.0'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'fuubar'
end
