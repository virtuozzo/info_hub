module OnApp::Responders
  module ControllerMethods
    extend ActiveSupport::Concern

    included do
      class_attribute :mimes_for_pagination
      clear_paginate_for
    end

    module ClassMethods
      # Defines whether paginate resoruce when invoking
      # <tt>respond_with</tt>.
      #
      # Default behavior without params:
      #   use instance variable named by controller name (UsersController -> @users)
      #   use mimes set by respond_to
      #   use 'index' as default action
      #
      # When mimes not given can be used only after respond_to
      #
      # Examples:
      #
      #   paginate_for :html, :xml, :json
      #
      # Specifies that pagination will be used for 'index' action
      # for <tt>:html</tt>, <tt>:xml</tt> and <tt>:json</tt>.
      #
      # To specify on per-action basis, use <tt>:actions</tt>
      # with an array of actions or a single action:
      #
      #   respond_to :html
      #   respond_to :xml, :json, :actions => [ :index, :own ]
      #
      # This specifies that resource will be paginated for 'index' action for <tt>:html</tt>
      # and for 'index' and 'own' actions for <tt>:xml</tt> and <tt>:json</tt>.
      #
      #   respond_to :resource_name => :templates
      #
      # This specifies that @templates variable will be paginated
      def paginate_for(*mimes)
        options = mimes.extract_options!
        mimes = self.mimes_for_respond_to.keys if mimes.blank?

        if options[:actions].is_a?(Hash)
          actions = options.delete(:actions)
        else
          actions = {}
          resource_name = options.delete(:resource_name) || self.controller_name
          Array.wrap(options.delete(:actions) || :index).each do |action|
            actions[action] = resource_name
          end
        end

        new = mimes_for_pagination.dup
        mimes.each do |mime|
          mime = mime.to_sym
          new[mime] ||= {}
          new[mime][:actions] ||= {}
          new[mime][:actions].merge! actions
        end

        self.mimes_for_pagination = new.freeze
      end
      alias :paginate :paginate_for

      def clear_paginate_for
        self.mimes_for_pagination = ActiveSupport::OrderedHash.new.freeze
      end
    end

    def page(custom_key = nil, options = {})
      page = params[:page]

      if params[:q].blank?
        session_key = session_key_for 'page', custom_key, options
        page ||= session[session_key]
        session[session_key] = page if page.present?
      end

      page
    end
    alias :page_for :page

    def query_for(custom_key = nil, options ={})
      session_value_for(custom_key: custom_key, key: 'q', param: params[:q], options: options)
    end

    def filter_state_for(custom_key = nil, options ={})
      session_value_for(custom_key: custom_key, key: 'state', param: params[:state], options: options)
    end

    def per_page(custom_key = nil, options = {})
      session_key = session_key_for 'per_page', custom_key, options
      per_page = params[:per_page] || session[session_key] || InfoHub.get(:pagination, :per_page)

      session[session_key] = per_page if per_page.present?

      per_page
    end
    alias :per_page_for :per_page

    private

    def session_key_for(param, custom_key, options = {})
      controller = options.delete(:controller) || controller_name
      action = options.delete(:action) || action_name

      [param, controller, action, custom_key].compact.join('_')
    end

    def session_value_for(custom_key:, key:, param:, options:)
      value = param
      session_key = session_key_for key, custom_key, options

      session[session_key] = value if value.present?
      value || session[session_key]
    end
  end
end

ActionController::Base.include(OnApp::Responders::ControllerMethods)
