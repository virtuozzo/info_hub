require_relative 'class_detector'

module Presenter
  module ViewHelper
    def present(object, presenter_class = nil, form = nil)
      presenter = ClassDetector.presenter_class(object, presenter_class).new(object, self, form)

      yield presenter if block_given?

      presenter
    end
  end
end
