module SimpleForm
  module Components
    module LocalizedErrors
      def localized_errors
        localized_error_text if has_errors?
      end

      private

      def localized_error_text
        case I18n.locale
        when :jp
          template.content_tag(:span, class: 'field-with-errors') do
            errors.inject(''.html_safe) do |localized_errors, error|
              localized_errors + template.content_tag(:span, class: 'text') do
                template.content_tag(:span, text_to_localized_error(error))
              end
            end
          end
        else
          template.content_tag(:span, class: 'field-with-errors') do
            template.content_tag(:span, class: 'text') do
              template.content_tag(:span, text_to_localized_error(errors.to_sentence))
            end
          end
        end
      end

      def text_to_localized_error(text)
        I18n.t('errors.format',
               :default   => '%{attribute} %{message}',
               :attribute => I18n.t('errors.attribute_name', default: 'This'),
               :message   => text
        )
      end
    end
  end

  module Inputs
    class Base
      include SimpleForm::Components::LocalizedErrors
    end
  end
end