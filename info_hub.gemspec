$:.push File.expand_path('../lib', __FILE__)

require 'info_hub/version'

Gem::Specification.new do |s|
  s.name = 'info_hub'
  s.version = InfoHub::VERSION
  s.authors = ['Virtuozzo']
  s.email = 'igor.sidorov@virtuozzo.com'
  s.homepage = 'https://github.com/virtuozzo/info_hub'
  s.summary = 'Handy library to read from YAML files'
  s.license = 'Apache 2.0'
  s.files = Dir['{app,config,db,lib}/**/*'] + %w( README.md )
  s.required_ruby_version = '>= 2.0'

  s.description = <<-EOF
    This gem delivers a simple DSL to read data from YAML files.
    That might be useful for storing some basic knowledge around the application.
  EOF

  s.add_dependency 'activesupport', '>= 4.0.2'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'pry'
end
