module OnApp::Responders
  module PaginatedResponder
    API_MIMES = [:json, :xml]
    attr_writer :resource

    protected
    def default_render
      paginate
      super
    end

    def set_pagination_headers
      if API_MIMES.include?(format) && resource.respond_to?(:current_page)
        controller.headers['X-Total'] = resource.total_entries.to_s
        controller.headers['X-Limit'] = resource.per_page.to_s
        controller.headers['X-Page'] = resource.current_page.to_s
      end
    end

    def paginate
      return if API_MIMES.include?(format) && controller.params[:page].blank? && controller.params[:per_page].blank?
      mimes = controller.class.mimes_for_pagination
      if mimes.keys.include?(format)
        actions = mimes[format][:actions]
        current_action = controller.action_name.to_sym
        if actions.keys.include?(current_action)
          resource_name = actions[current_action]
          per_page = controller.per_page
          per_page = [OnApp.configuration.pagination_max_items_limit.to_i, controller.per_page.to_i].min unless API_MIMES.include?(format)
          self.resource = self.resource.paginate(:per_page => per_page, :page => controller.page) if self.resource
          controller.instance_variable_set "@#{resource_name}", self.resource
          set_pagination_headers
        end
      end

      self.resource
    end
  end
end
