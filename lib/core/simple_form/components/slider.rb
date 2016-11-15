# encoding: utf-8
module SimpleForm
  module Components
    module Slider
      def slider(wrapper_options)
        if options.has_key?(:slider)
          slider_element(options[:slider])
        else
          nil
        end
      end

      private

      def slider_element(options)
        target  = "##{@builder.object_name}_#{attribute_name}".gsub(/[\[\]]/, '[' => '_', ']' => '')
        slider  = template.content_tag(:div, '', options.merge(target: target, class: 'slider'))
        slider += slider_unlimited_element if options[:unlimited]
        slider
      end

      def slider_unlimited_element
        id      = "#{@builder.object_name}_#{attribute_name}_unlimited".gsub(/[\[\]]/, '[' => '_', ']' => '')
        checked = @builder.object.send(attribute_name).is_a?(Integer) && @builder.object.send(attribute_name).zero?
        @builder.check_box(attribute_name, {id: id, checked: checked}, 0, 1) + @builder.template.label_tag(id, '&#8734;'.html_safe)
      end
    end
  end

  module Inputs
    class Base
      include SimpleForm::Components::Slider
    end
  end
end
