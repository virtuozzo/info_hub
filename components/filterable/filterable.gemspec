$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'filterable/version'

Gem::Specification.new do |s|
  s.name        = 'filterable'
  s.version     = Filterable::VERSION
  s.authors     = ['Oleg Kariuk']
  s.email       = ['onapp@onapp.com']
  s.summary     = 'Filtering by Rails scopes'

  s.files = Dir['{app,config,db,lib}/**/*'] + %w(Rakefile README.rdoc)

  s.test_files = Dir['spec/**/*']

  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'factory_girl_rails'
end
