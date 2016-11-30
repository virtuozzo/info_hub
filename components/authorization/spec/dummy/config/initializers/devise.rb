require 'devise'

Devise.setup do |config|
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.secret_key = '64952484558620fe67992d25f37f1e2c0a70c5dace0ff7e4223c651af85cb2b077c4ecac3fcfbe8665986a1906628b1c61e001e9679f95e49e5bec694d83f0a8'
end
