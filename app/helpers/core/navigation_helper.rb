module Core::NavigationHelper
  def render_section_header(options = {}, &block)
    title = begin
      options.delete(:title) || t('.title', raise: true)
    rescue I18n::MissingTranslationData
      t('.help.title')
    end
    section_class = ['section_header', options.delete(:section_class)].join(' ').strip
    header_class = options.delete(:header_class)

    content_tag :div, class: section_class do
      content_tag(:h2, title, class: header_class) + (capture(&block) if block_given?)
    end
  end

  def render_tabs_for(subject, options = {})
    wrapper_class = ['tab-nav', options.delete(:class)].join(' ').strip
    options[:items] = tab_items_for(subject)

    content_tag(:div, class: wrapper_class) do
      render_navigation options
    end
  end

  def render_tabs_header_for(subject, options = {})
    wrapper_class = ['tab-nav-header tab-nav', options.delete(:class)].join(' ').strip
    options[:items] = tab_items_for(subject)

    content_tag(:div, class: wrapper_class) do
      render_navigation options
    end
  end

  def tab_items_for(symbol_or_object)
    args = if symbol_or_object.is_a?(Symbol)
             ["#{symbol_or_object}_tab_items"]
           else
             ["#{symbol_or_object.class.model_name.name.underscore.parameterize('_')}_tab_items", symbol_or_object]
    end

    __send__(*args)
  end

  def render_section_header_button(type, options = {})
    condition = options.fetch(:condition) { true }
    return unless condition

    options.delete(:condition)

    icon = options[:icon] || type

    options[:class] = ['button control right', options.delete(:class)].join(' ').strip
    options[:icon] = [icon, 'icon'].join(' ').strip
    options[:content_text] ||= t(type, scope: 'actions')

    widget_round_button options
  end

  def render_add_button(options = {})
    render_section_header_button 'add', options
  end

  def round_button(options = {})
    content_text = options.delete(:content_text) || t('.submit')

    options[:class] = ('round-button ' << options[:class].to_s).strip
    options[:type] ||= 'submit'

    # Deprecated method in Rails 3.1
    # add_confirm_to_attributes!(options, options.delete(:confirm))
    confirm = options.delete(:confirm)
    options['data-confirm'] = confirm if confirm

    content_tag(:button, content_text, options)
  end

  def widget_round_button(options = {})
    content_text = options.delete(:content_text) || t('.submit')

    href = options.delete(:href) || ''
    options[:title] ||= content_text

    icon = options.delete(:icon) || nil
    icon_only = 'icon_only'
    icon_only = nil if options.delete(:show_text)
    button_class = options[:class] || 'button'
    options[:class] = [button_class, icon, icon_only].compact.join(' ')

    link_to(href, options) do
      icon_only ? '' : content_tag(:b, content_text)
    end
  end
end
