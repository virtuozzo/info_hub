$:.push File.expand_path("../lib", __FILE__)
require 'permissions/version'

Gem::Specification.new do |s|
  s.name        = 'permissions'
  s.version     = Permissions::VERSION
  s.authors     = ['OnApp devs']
  s.email       = ['onapp@onapp.com']
  s.summary     = 'Permissions'
  s.description = 'Lib to handle permissions'

  s.files = Dir['{app,config,db,lib}/**/*'] + %w(README.rdoc)

  s.add_dependency 'activesupport', '3.2.22'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'pry'
end
