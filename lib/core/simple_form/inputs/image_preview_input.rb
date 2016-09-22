module SimpleForm
  module Inputs
    class ImagePreviewInput < Base
      def input
        html = @builder.file_field(attribute_name, input_html_options)
        html << image_preview_widget if object.send("#{attribute_name}?")
        html.html_safe
      end

      private

      def image_preview_widget
        template.tag(:br) + image_preview_picture + image_preview_action
      end

      def image_preview_picture
        width  = input_html_options.delete(:preview_width) || 48
        height = input_html_options.delete(:preview_width) || 48
        template.image_tag(object.send(attribute_name).url, width: width, height: height)
      end

      def image_preview_action
        attr = :"remove_#{attribute_name}"
        @builder.check_box(attr) + @builder.label(attr)
      end
    end
  end
end