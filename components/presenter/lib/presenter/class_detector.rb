module Presenter
  module ClassDetector
    def self.presenter_class(object)
      "#{object.class}Presenter".safe_constantize ||
        "#{object.class.base_class}Presenter".constantize
    end
  end
end