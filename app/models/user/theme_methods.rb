class User
  validates :system_theme, inclusion: OnApp[:available_system_themes], allow_blank: true

  # def theme_logo_url
  # def theme_favicon_url
  # def theme_wrapper_top_background_image_url
  # def theme_wrapper_bottom_background_image_url
  # def theme_body_background_image_url
  %w(
    logo
    favicon
    wrapper_top_background_image
    wrapper_bottom_background_image
    body_background_image
  ).each do |method_name|
    delegate :"#{method_name}_url", to: :theme, prefix: true, allow_nil: true
  end

  # def theme_powered_by_hide
  # def theme_disable_logo
  # def theme_disable_favicon
  # def theme_disable_wrapper_top_background_image
  # def theme_disable_wrapper_bottom_background_image
  # def theme_disable_body_background_image
  %w(
    powered_by_hide
    disable_logo
    disable_favicon
    disable_wrapper_top_background_image
    disable_wrapper_bottom_background_image
    disable_body_background_image
  ).each do |method_name|
    delegate method_name, to: :theme, prefix: true, allow_nil: true
  end

  # def theme_label
  # def theme_application_title
  # def theme_powered_by_url
  # def theme_powered_by_link_title
  # def theme_powered_by_color
  # def theme_powered_by_text
  # def theme_wrapper_background_color
  # def theme_body_background_color
  # def theme_html_header
  # def theme_html_footer
  %w(
    label
    application_title
    powered_by_url
    powered_by_link_title
    powered_by_color
    powered_by_text
    wrapper_background_color
    body_background_color
    html_header
    html_footer
  ).each do |method_name|
    define_method :"theme_#{method_name}" do
      theme ? theme.public_send(method_name) : ''
    end
  end
end
