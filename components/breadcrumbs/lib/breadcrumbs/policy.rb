module Breadcrumbs
  module Policy
    def self.vm_child?(params)
      (params.keys & Breadcrumbs.parent_ids).present?
    end
  end
end
