module OnApp
  class Configuration
    module ConfigAttribute
      BOOLEAN_SETTER   = :boolean
      NUMERICAL_GETTER = :numerical

      def attributes_to_save_to_file
        @attributes_to_save_to_file ||= []
      end

      def defaults
        @defaults ||= {}
      end

      # DSL to add a new attribute:
      # class Configuration
      #   config_attribute :some_attribute, save_to_file: true, getter: :numerical, setter: :boolean, default: 5, presence: true, length: { maximum: 60 }
      # end
      # :some_attribute - name of new attribute
      # :save_to_file - add new attribute to the list of attributes to save to file.
      # :getter - define a custom getter
      # :setter - define a custom setter
      # :default - provides a default value for attribute, and store it in `defaults`. (can be `false`, but not `nil`)
      # *attributes - some validations for attribute.
      def config_attribute(attribute, getter: true, setter: true, save_to_file: true, default: nil, **arguments)
        if getter == NUMERICAL_GETTER
          define_method attribute do
            instance_variable_get("@#{ attribute }").to_i
          end
        elsif getter
          attr_reader attribute
        end

        if setter == BOOLEAN_SETTER
          define_method "#{ attribute }=" do |value|
            value = Utils::AR.value_to_boolean(value)
            instance_variable_set("@#{ attribute }", value)
          end
        elsif setter
          attr_writer attribute
        end

        defaults.merge!(attribute => default) unless default.nil?
        attributes_to_save_to_file.push(attribute) if save_to_file
        validates(attribute, arguments) if arguments.any?
      end
    end
  end
end
