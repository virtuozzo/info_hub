module OnApp
  class AttributeAssigningError < StandardError
  end

  class WrongTimeRange < StandardError
    def initialize(msg = nil)
      super msg || I18n.t('wrong_time_range')
    end
  end

  class Errors
    # Add all Exception classes that can show their message in API calls
    def self.show_error_message_in_api_for?(exception)
      [].include?(exception.class)
    end
  end
end
