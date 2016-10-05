require_relative 'authorizer'

module Permissions
  module BaseModelMethods
    extend ActiveSupport::Concern

    def authorized_for?(user, action)
      Authorizer.authorized_object?(self, user, action)
    end

    module ClassMethods
      # Specially for ImageTemplate
      def user_scope
        where(arel_table[:user_id].not_eq(nil))
      end

      def all_scope(*args)
        all.readonly(false)
      end

      def authorized_for?(user, action, options = {})
        Authorizer.authorized_class?(self, user, action, options)
      end

      def owned(user, action = :read)
        Authorizer.owned_scope(self, user, action)
      end
    end
  end
end
