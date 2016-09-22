Breadcrumbs.tap do |cfg|
  cfg.logger = Rails.logger
  cfg.show_errors = Rails.env.production?
  cfg.root_path = '/'
end
