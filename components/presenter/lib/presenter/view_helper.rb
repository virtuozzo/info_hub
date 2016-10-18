require_relative 'class_detector'

module Presenter
  module ViewHelper
    def present(object, presenter_class = nil)
      presenter = ClassDetector.presenter_class(object).new(object, self)

      yield presenter if block_given?

      presenter
    end
  end
end