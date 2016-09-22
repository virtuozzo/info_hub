module Permissions
  module Factory
    module Errors
      class Base < StandardError
      end

      class UnsupportedClass < Base
      end

      class UnsupportedAction < Base
      end

      class UnsupportedTrait < Base
      end

      class UnsupportedOptions < Base
      end

      class TargetIsNotSpecified < Base
      end

      class DoubleDefinition < Base
      end

      class DoubleActionDefinition < Base
      end

      class DoubleTraitDefinition < Base
      end

      class InvalidDependency < Base
      end
    end
  end
end
