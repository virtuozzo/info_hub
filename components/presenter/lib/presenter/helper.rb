module Presenter
  module Helper
    def present(object, presenter_class = nil)
      presenter_class ||= "#{object.class}Presenter".safe_constantize ||
                          "#{object.class.base_class}Presenter".constantize

      presenter = presenter_class.new(object, self)

      yield presenter if block_given?

      presenter
    end
  end
end
