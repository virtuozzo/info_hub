require 'will_paginate/array'

module WillPaginate
  module ActiveRecord
    module Pagination
      class << self
        attr_accessor :per_page
      end

      alias_method :orig_paginate, :paginate
      def paginate(options)
        Pagination.per_page = options.fetch(:per_page, per_page)

        rel = orig_paginate(options)
        rel = rel.limit(rel.total_entries) if rel.per_page.zero?
        rel = rel.page(rel.total_pages) if rel.out_of_bounds?
        rel
      end
    end
  end

  module CollectionMethods
    def max_items_limit
      @max_items_limit ||= OnApp.configuration.pagination_max_items_limit
    end
  end

  class Collection
    def current_page=(number)
      @current_page = WillPaginate::PageNumber(number)
    end
  end

  module ViewHelpers
    class LinkRenderer
      alias_method :orig_to_html, :to_html
      def to_html
        use_container = @options[:container]
        @options[:container] = false
        html = limits_html
        html.insert 0, orig_to_html if @collection.total_pages > 1

        use_container && html.present? ? html_container(html) : html
      end

      protected

      def all_items
        if !@options[:skip_all] && @collection.total_entries > items_limits.last && @collection.total_entries <= @collection.max_items_limit
          label = @template.will_paginate_translate :all_label
          #css_class = rel = 'all_items'
          #if @collection.total_entries == @collection.per_page #current_page.zero?
          #  css_class += ' current'
          #  tag(:em, label, :class => css_class)
          #else
          #  link(label, limit_url('all'), :rel => rel, :class => css_class)
          #end

          selected = @collection.total_entries == @collection.per_page

          @template.options_for_select [[label + ' Items', 'all', 'data-link' => limit_url('all')]], selected: ('all' if selected)
        end
      end

      def per_page_numbers
        #@per_page_numbers ||= items_limits.map do |items_limit|
        #  if @collection.per_page == items_limit
        #    tag(:em, items_limit, :class => 'current')
        #  else
        #    link(items_limit, limit_url(items_limit))
        #  end
        #end

        @per_page_numbers ||= @template.options_for_select items_limits.collect {|i| [i.to_s + ' Items', i, 'data-link' => limit_url(i)]}, @collection.per_page
      end

      def limits_html
        items_limits
        return '' if per_page_numbers.blank? || @options[:skip_limits]

        #html = (Array.wrap(per_page_numbers).push all_items).compact.join(@options[:link_separator])
        #html.insert 0, tag(:span, @template.will_paginate_translate(:limits_label))

        tag(:div, @template.select_tag('limits', per_page_numbers + all_items, :id => "limits_#{@collection.object_id}"), :class => 'limits')
      end

      def limit_url(limit)
        action = @template.params[:action]
        action = @options[:params].fetch(:action) {action} if @options[:params]
        url_params = @template.params.merge(:per_page => limit, :action => action).reject { |key| key.to_sym == @options[:param_name] }
        @template.params.delete(:per_page)

        url_scope.url_for url_params
      end

      def items_limits
        @items_limits = [] if @collection.total_pages == 1 && @collection.per_page == items_limits_const.first
        @items_limits ||= items_limits_const.take_while { |limit| limit <= @collection.total_entries && limit <= @collection.max_items_limit }
      end

      private

      def items_limits_const
        InfoHub.get(:pagination, :items_limits)
      end
    end

    def will_paginate(collection, options = {})
      return unless collection.respond_to?(:current_page)

      options = WillPaginate::ViewHelpers.pagination_options.merge(options)

      options[:previous_label] ||= will_paginate_translate(:previous_label) { '&#8592; Previous' }
      options[:next_label]     ||= will_paginate_translate(:next_label) { 'Next &#8594;' }

      # get the renderer instance
      renderer = instantiate_renderer options[:renderer]
      # render HTML for pagination
      renderer.prepare collection, options, self
      renderer.to_html.html_safe
    end

    def instantiate_renderer renderer
      case renderer
      when nil
        raise ArgumentError, ":renderer not specified"
      when String
        klass = if renderer.respond_to? :constantize
                  renderer.constantize
                else
                  Object.const_get(renderer)
                end
        klass.new
      when Class
        renderer.new
      else
        renderer
      end
    end
  end

  module ActionView
    def paginated_section(*args, &block)
      collection = args.first
      options = args.extract_options!

      no_content_text = if collection.blank?
        options.merge!(model: collection.respond_to?(:model_name) ? collection.model_name.to_s.constantize : nil) unless options.key?(:model)

        humanize_message = options.delete(:humanize_message) { true }
        hide_message = options.delete(:hide_message) { false }

        if hide_message
          ''
        else
          unless collection.respond_to?(:total_pages)
            def collection.total_pages
              0
            end
            def collection.total_entries
              0
            end
          end

          message = page_entries_info(collection, options)
          message = message.humanize if humanize_message
          no_content(nil, nil, content_text: message)
        end
      end

      config = ConfigForPaginatedSection.new(:view            => self,
                                             :collection      => collection,
                                             :pagination      => will_paginate(collection, options),
                                             :no_content_text => no_content_text)
      result = capture(config, &block)
      unless config.present_called?
        result = config.present { result }
      end

      unless config.pagination_called?
        result = result + config.pagination
      end

      result
    end

    class LinkRenderer
      protected

      def url_scope
        @options[:url_scope] || @template
      end

      def url(page)
        @base_url_params ||= begin
          url_params = merge_get_params(default_url_params)
          url_params[:only_path] = true
          merge_optional_params(url_params)
        end

        url_params = @base_url_params.dup
        add_current_page_param(url_params, page)

        url_scope.url_for(url_params)
      end
    end
  end

  class ConfigForPaginatedSection
    attr_reader :view, :collection, :no_content_text

    def initialize(args)
      @view = args[:view]
      @collection = args[:collection]
      @pagination = args[:pagination].to_s
      @pagination_called = false
      @empty_called = false
      @present_called = false
      @no_content_text = args[:no_content_text]
    end

    def pagination
      @pagination_called = true
      @pagination.html_safe
    end

    def pagination_called?
      @pagination_called
    end

    def empty_called?
      @empty_called
    end

    def present_called?
      @present_called
    end

    def empty(&block)
      @empty_called = true
      if collection.empty?
        view.capture(&block)
      end
    end

    def present(&block)
      @present_called = true
      if collection.empty?
        no_content_text unless empty_called?
      else
        view.capture(&block)
      end
    end
  end
end

class Array
  def paginate(options = {})
    page     = options[:page] || 1
    per_page = options[:per_page] || WillPaginate.per_page
    per_page = self.length if per_page.to_i.zero?
    total    = options[:total_entries] || self.length

    WillPaginate::Collection.create(page, per_page, total) do |pager|
      pager.current_page = pager.total_pages if pager.out_of_bounds?
      pager.replace self[pager.offset, pager.per_page].to_a
    end
  end
end
