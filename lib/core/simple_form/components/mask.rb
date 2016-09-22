module SimpleForm
  module Components
    module Mask
      def mask
        options[:mask]
      end
    end
  end

  module Inputs
    class Base
      include Components::Mask
    end
  end
end