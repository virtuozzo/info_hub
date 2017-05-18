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

    def page_title!
      page_title t('.title')
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

    def render_global_custom_js_link
      javascript_include_tag '/themes/custom' if File.exists?(Rails.root.join('public', 'themes', 'custom.js'))
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
      [{ items: [nav_item_for(OnApp::Application.routes.url_helpers.root_path)] }]
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

    # This is temporary solution for pagination bug on pages extracted to engines
    # it does not affect pagination in interface in any way
    def format_paginator(section)
      section.gsub("\"/ver/", "\"#{controller.env['PATH_INFO']}/").html_safe
    end

    def round_link(link_label, link_url, options = {}, position = 'right')
      link_class = ['button', position, options.delete(:class)].join(' ').strip
      options[:class] = link_class
      link_to link_label, link_url, options
    end

    def render_action_buttons(actions = {})
      return if actions.blank?

      content_tag :div, class: 'actions' do
        content_tag(:a, class: 'tasksy icon cogtasks') do
          content_tag :span, '', class: 'taskyar'
        end +
        content_tag(:div, class: 'taskymenu') do
          content_tag :ul, '' do
            actions.collect do |name, link|
              concat content_tag(:li, link.html_safe, data: {action: name})
            end
          end
        end
      end
    end

    # go_to_type:
    #   => :action
    #   => :path
    def back_button_links(go_to: :index, go_to_type: :action, content_text: I18n.t('links.back'))
      options_for_content_tag = { class: 'back button' }

      if go_to_type == :action
        options_for_content_tag[:href] = url_for(controller: controller_name.to_s, action: go_to.to_s)
        Rails.application.routes.recognize_path options_for_content_tag[:href]
      else
        options_for_content_tag[:href] = go_to
      end

      content_tag(:a, options_for_content_tag) do
        content_text
      end
    end

    def no_content(*args)
      options = { content_text: t('index.no_content') }.merge(args.extract_options!)
      content_tag(:div, class: 'no_content') do
        content_tag(:p) { options[:content_text].html_safe }
      end
    end
  end
end
