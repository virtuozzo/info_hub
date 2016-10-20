$:.push File.expand_path('../lib', __FILE__)

require 'presenter/version'

Gem::Specification.new do |s|
  s.name        = 'presenter'
  s.version     = Presenter::VERSION
  s.authors     = ['Billing Team']
  s.email       = %w(onapp@onapp.com)
  s.summary     = 'Presenter'
  s.description = 'Presenters give an object oriented way to approach view helpers.'

  s.files = Dir['{app,config,db,lib}/**/*'] + %w(README.md)

  s.add_dependency 'actionpack', '3.2.22'

  s.add_development_dependency 'rspec'
end
