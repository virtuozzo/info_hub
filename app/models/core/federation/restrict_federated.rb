module Core
  module Federation
    module RestrictFederated
      extend ActiveSupport::Concern

      module ClassMethods
        def restrict_federated!(options = {})
          attr_accessor :no_supplied_restrictions, :no_traded_restrictions

          hooks = options.fetch :hooks, [:before_save, :before_destroy]
          hooks.each do |hook|
            send(hook, :restrict_federated)
          end
        end
      end

      def no_federation_restrictions!
        self.no_supplied_restrictions = true
        self.no_traded_restrictions   = true
      end

      def restrict_federated
        federated = false
        federated ||= supplied? unless no_supplied_restrictions
        federated ||= traded?   unless no_traded_restrictions

        if federated
          errors.add(:base, :federated)
          false
        end
      end
    end
  end
end
