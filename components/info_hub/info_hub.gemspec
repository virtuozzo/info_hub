$:.push File.expand_path('../lib', __FILE__)

require 'info_hub/version'

Gem::Specification.new do |s|
  s.name        = 'info_hub'
  s.version     = InfoHub::VERSION
  s.authors     = ['OnApp devs']
  s.email       = %w( onapp@onapp.com )
  s.summary     = 'InfoHub'
  s.description = 'System-wide configuration.'

  s.files = Dir['{app,config,db,lib}/**/*'] + %w( README.md )

  s.add_dependency 'activesupport', '3.2.22'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fuubar'
end
