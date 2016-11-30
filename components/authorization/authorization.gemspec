$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'authorization/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'authorization'
  s.version     = Authorization::VERSION
  s.authors     = ['OnApp devs']
  s.email       = ['onapp@onapp.com']
  s.summary     = 'Methods which live on top of Devise'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['Rakefile']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'mysql2'
  s.add_dependency 'devise'
  s.add_dependency 'rails'

  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'pry'
end
