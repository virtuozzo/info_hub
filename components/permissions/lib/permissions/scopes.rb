module Permissions
  module Scopes
    def self.by_billing_plan(klass, user)
      "#{ self }::#{ __callee__.to_s.classify }::#{ klass }Scope".constantize.new(user).build
    end

    class << self
      alias_method :by_user_group, :by_billing_plan
      alias_method :by_user, :by_billing_plan
    end
  end
end
