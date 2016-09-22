module Breadcrumbs
  module Helpers
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper

    def collect_breadcrumbs
      controller_breadcrumbs = set_breadcrumbs
      return [] unless controller_breadcrumbs.present?

      breadcrumbs = [{ title: t(:root, scope: :breadcrumbs), url: Breadcrumbs.root_path }]

      namespace_crumb = Breadcrumbs::CRUDCreator.parse_from_url(request.url, controller_name)

      breadcrumbs << namespace_crumb if namespace_crumb.present?

      unless controller_breadcrumbs == true
        breadcrumbs += controller_breadcrumbs.compact.flatten
      end

      breadcrumbs << { title: @page_title_text, url: '#' } if action_name != Breadcrumbs::CRUDCreator::INDEX

      breadcrumbs
    end

    def render_breadcrumbs(breadcrumbs = collect_breadcrumbs)
      return unless breadcrumbs.present?

      breadcrumbs_text = ''.html_safe
      item_max_width_css = "max-width: #{(100.00 / breadcrumbs.count).floor}%;"

      content_tag(:div, class: 'breadcrumbs') do
        content_tag(:ul) do
          last = breadcrumbs.pop
          breadcrumbs.each do |breadcrumb|
            link = Breadcrumbs.show_errors ? rescue_breadcrumb(breadcrumb) : breadcrumb_link(breadcrumb)
            breadcrumbs_text << content_tag(:li, link, style: item_max_width_css)
          end
          if last
            breadcrumbs_text << content_tag(:li, class: :active, style: item_max_width_css) do
              content_tag :span, last[:title], title: last[:title]
            end
          end
        end
      end
    end

    def breadcrumb_link(breadcrumb, url = true)
      title = breadcrumb[:title]

      return link_to(title, '#', title: title) unless url

      link_to(title, breadcrumb[:url], title: title)
    end

    def rescue_breadcrumb(breadcrumb)
      breadcrumb_link(breadcrumb)
    rescue NoMethodError
      Breadcrumbs.logger.warn("URL for `#{ breadcrumb[:url] }` is invalid")
      breadcrumb_link(breadcrumb, false)
    end
  end
end
