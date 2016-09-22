module OnApp
  class Configuration
    module CustomAccessors
      # creates getters with preliminary conversion of it's value to integer.
      # Example:
      # def backup_taker_delay
      #   @backup_taker_delay.to_i
      # end
      def define_numerical_getters(*methods)
        methods.each do |method|
          define_method method do
            instance_variable_get("@#{method}").to_i
          end
        end
      end

      def define_boolean_setters(*methods)
        methods.each do |method|
          define_method "#{method}=" do |value|
            instance_variable_set("@#{method}", Utils::AR.value_to_boolean(value))
          end
        end
      end
    end
  end
end