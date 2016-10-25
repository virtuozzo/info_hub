module Core
  module ApplicationHelper
    include Breadcrumbs::Helpers

    def safe_render(partial)
      render partial if partial
    end

    def page_title(text, icon = nil)
      @page_title_text = text
      @page_title = (icon.blank? ? '' : icon_tag(icon, text)) + ' ' + text
    end

    def render_page_title(text = '')
      (text + (@page_title_text || '')).gsub(/\-/, '&#45;').gsub(/[|>]/, '&#8250;')
    end

    def application_title
      if current_user && current_user.theme_application_title.present?
        current_user.theme_application_title
      else
        OnApp.configuration.app_name
      end
    end

    def caption(text = nil)
      @caption = text and return if text.present?
      @caption || t('sessions.new.title', app_name: OnApp.configuration.app_name)
    end

    def render_favicon
      if current_user.theme_favicon_url && !current_user.theme_disable_favicon
        favicon_link_tag(current_user.theme_favicon_url)
      else
        favicon_link_tag('/favicon.ico')
      end
    end

    def system_theme
      if OnApp[:available_system_themes].include?(params[:system_theme])
        params[:system_theme]
      else
        current_user.try(:system_theme).presence || OnApp[:system_theme]
      end
    end

    def render_global_custom_css_link
      stylesheet_link_tag '/themes/custom' if File.exists?(Rails.root.join('public', 'themes', 'custom.css'))
    end

    def render_custom_css_link
      if current_user.theme
        tag(:link, rel: 'stylesheet', type: Mime::CSS, media: 'screen', href: ThemePresenter.new(current_user.theme).stylesheet_url)
      end
    end

    def render_custom_header
      raw current_user.theme_html_header
    end

    def render_custom_footer
      raw current_user.theme_html_footer
    end

    def application_image_logo
      return if current_user.theme_disable_logo

      url = current_user.theme_logo_url || "themes/#{system_theme}/logo.png"

      image_tag(url, title: t('powered_by') + ' ' + OnApp.configuration.app_name)
    end

    def nav_item_for(path, options = {})
      item_controller = options[:controller] || Rails.application.routes.recognize_path(path, method: :get)[:controller]

      nav_key = options.delete(:key) || item_controller
      icon_class = 'icon' unless options.delete(:skip_icon)
      nav_title = options.delete(:name) || t(".#{options.delete(:t) || item_controller}")
      options[:"data-tooltip"] = nav_title
      nav_name  = content_tag(:span, nav_title, :class => icon_class)
      items = options.delete(:items)
      options[:class] = item_controller unless options[:class]

      if options[:counter]
        nav_name += content_tag(:span, options[:counter], class: 'count')
      end

      {:key => nav_key, :name => nav_name  , :url => path, :items => items, :options => options}
    end

    def core_main_navigation_groups
      [{ items: [nav_item_for(root_path)] }]
    end

    def block_to_partial(partial_name, options = {}, &block)
      options.merge!(body: capture(&block)) if block

      render(partial: partial_name, locals: options)
    end

    def render_powered_by
      return '' if current_user.theme_powered_by_hide

      url   = current_user.theme_powered_by_url.present? ? current_user.theme_powered_by_url : 'http://www.onapp.com/'
      url   = 'http://' + url unless url.start_with?('http')
      text  = current_user.theme_powered_by_text.present? ? current_user.theme_powered_by_text : application_title
      title = if current_user.theme_powered_by_link_title.present?
                current_user.theme_powered_by_link_title
              else
                t('layouts.application.app_title_hint', app_name: OnApp.configuration.app_name)
              end

      block_to_partial 'shared/powered_by', powered_by_text: text, powered_by_url: url, powered_by_link_title: title
    end
  end
end
