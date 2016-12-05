module Restrictions
  class RestrictionTypeGetter < Struct.new(:user_id, :resource)
    class UnsupportedResourceType < StandardError
    end

    def self.get(user_id, resource)
      new(user_id, resource).get_resources
    end

    def get_resources
      Restrictions::Resource.restriction_type_by_user_id_and_identifier(user_id, get_identifier)
    end

    private

    def get_identifier
      if resource.is_a? String
        resource
      elsif resource.is_a? Symbol
        resource.to_s
      elsif resource.is_a? Class
        resource.to_s.underscore.tr('/','_').pluralize
      else
        raise UnsupportedResourceType, "Unsupported resource type: #{ resource.class }"
      end
    end
  end
end
