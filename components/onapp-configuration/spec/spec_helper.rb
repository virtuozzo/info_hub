require 'onapp-configuration'

OnApp::Configuration.rails_root = Pathname.new(File.expand_path('../fixtures', __FILE__))
OnApp::Configuration.config_file_path = Pathname.new(File.expand_path('../fixtures/on_app.yml', __FILE__))
