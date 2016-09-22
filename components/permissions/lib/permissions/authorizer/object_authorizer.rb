module Permissions
  module Authorizer
    class ObjectAuthorizer
      attr_reader :object, :user, :action

      def initialize(object, user, action)
        @object = object
        @user = user
        @action = action
      end

      def authorized?
        return false if object.respond_to?(:deny_permissions?) && object.deny_permissions?(user, action)

        return true if class_authorized_for?(user, action, scope: :all)
        return true if class_authorized_for?(user, action, scope: :own)    && owners.include?(user)
        return true if class_authorized_for?(user, action, scope: :public) && object.respond_to?(:user) && object.user.nil?
        return true if class_authorized_for?(user, action, scope: :user)   && object.respond_to?(:user) && object.user.present?

        false
      end

      private

      def owners
        return [object.user] if object.respond_to? :user
        return object.users  if object.respond_to? :users
        return [object]      if object.is_a? Permissions.user_class_name.constantize

        Permissions.user_relations.inject(collection_owners) do |result, name|
          result << object.public_send(name).try(:user) if object.respond_to?(name)

          result
        end.compact.uniq
      end

      def class_authorized_for?(*args)
        object.class.authorized_for?(*args)
      end

      def collection_owners
        Permissions.user_collection_relations.inject([]) do |result, name|
          result.push(*Array(object.public_send(name).try(:users))) if object.respond_to? name

          result
        end
      end
    end
  end
end
