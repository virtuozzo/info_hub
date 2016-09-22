require 'active_support/core_ext/module'

module Permissions
  module Authorizer
    class OwnerScopeProducer
      attr_reader :klass, :user, :action

      delegate :authorized_for?, to: :klass

      def initialize(klass, user, action)
        @klass = klass
        @user = user
        @action = action
      end

      def owned_scope
        result = klass.all_scope(user, action)
        result = apply_roles_sets_restrictions(result)

        return result if authorized_for?(user, action, scope: :all)

        public_scp  = authorized_for?(user, action, scope: :public)
        own_scp     = authorized_for?(user, action, scope: :own)
        user_scp    = authorized_for?(user, action, scope: :user)
        company_scp = authorized_for?(user, action, scope: :company)

        result = if    public_scp && user_scp then result
                 elsif public_scp && own_scp  then result.by_user([user, nil])
                 elsif public_scp             then result.by_user(nil)
                 elsif user_scp               then result.user_scope
                 elsif own_scp && company_scp then result.by_user([user, user.company])
                 elsif own_scp                then result.by_user(user)
                 elsif company_scp            then result.by_user(user.company)
                 else  klass.none
                 end
        result
      end

      private

      def apply_roles_sets_restrictions(scope)
        Restrictions::RestrictionTypeGetter.get(user.id, klass).inject(scope) do |result, restriction|
          result.public_send(restriction, user)
        end
      end
    end
  end
end
