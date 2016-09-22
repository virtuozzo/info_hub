require 'core/simple_form/components/localized_errors'
require 'core/simple_form/components/slider'
require 'core/simple_form/components/mask'
require 'core/simple_form/inputs/image_preview_input'

SimpleForm.setup do |config|
  config.wrappers :default, tag: 'dl', error_class: 'field-with-errors' do |b|
    b.use :html5
    b.use :placeholder

    b.optional :maxlength
    b.optional :pattern
    b.use :min_max
    b.optional :readonly

    b.wrapper tag: 'dt' do |dt|
      dt.use :label
    end

    b.wrapper tag: 'dd' do |dd|
      dd.use :input
      dd.use :mask, wrap_with: { tag: 'span', class: 'units' }
      dd.use :hint, wrap_with: { tag: 'span', class: 'hint' }
      dd.use :localized_errors
    end
  end

  config.wrappers :slider, tag: 'dl', class: 'with_slider', error_class: 'field-with-errors' do |b|
    b.use :html5
    b.use :placeholder

    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper tag: 'dt' do |dt|
      dt.use :label
    end

    b.wrapper tag: 'dd' do |dd|
      dd.use :slider
      dd.use :input
      dd.use :mask, wrap_with: { tag: 'span', class: 'units' }
      dd.use :hint, wrap_with: { tag: 'span', class: 'hint' }
      dd.use :localized_errors
    end
  end

  config.wrappers :checkbox, tag: 'dl', error_class: 'field-with-errors' do |b|
    b.use :html5
    b.use :placeholder

    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper tag: 'dt' do |dt|
      dt.use :localized_errors
      dt.use :input
      dt.use :label
    end
  end

  config.wrappers :clear, tag: false do |b|
    b.use :label
    b.use :input
    b.use :localized_errors
  end

  config.wrappers :clear_checkbox, tag: false do |b|
    b.use :input
    b.use :label
  end

  config.wrappers :no_label, tag: false do |b|
    b.use :input
    b.use :localized_errors
  end

  config.default_wrapper = :default
  config.boolean_style   = :inline
  config.button_class    = 'round-button'

  # Method used to tidy up errors.
  # config.error_method = :first

  # Default tag used for error notification helper.
  config.error_notification_tag = :div

  # CSS class to add for error notification helper.
  config.error_notification_class = 'alert alert-error'

  # ID to add for error notification helper.
  # config.error_notification_id = nil

  # Series of attempts to detect a default label method for collection.
  # config.collection_label_methods = [ :to_label, :name, :title, :to_s ]

  # Series of attempts to detect a default value method for collection.
  # config.collection_value_methods = [ :id, :to_s ]

  # You can wrap a collection of radio/check boxes in a pre-defined tag, defaulting to none.
  # config.collection_wrapper_tag = nil

  # You can define the class to use on all collection wrappers. Defaulting to none.
  # config.collection_wrapper_class = nil

  # You can wrap each item in a collection of radio/check boxes with a tag,
  # defaulting to :span. Please note that when using :boolean_style = :nested,
  # SimpleForm will force this option to be a label.
  # config.item_wrapper_tag = :span

  # You can define a class to use in all item wrappers. Defaulting to none.
  # config.item_wrapper_class = nil

  # How the label text should be generated altogether with the required text.
  # config.label_text = lambda { |label, required| "#{required} #{label}" }

  # You can define the class to use on all labels. Default is nil.
  config.label_class = 'control-label'

  # You can define the class to use on all forms. Default is simple_form.
  # config.form_class = :simple_form

  # You can define which elements should obtain additional classes
  # config.generate_additional_classes_for = [:wrapper, :label, :input]

  # Whether attributes are required by default (or not). Default is true.
  # config.required_by_default = true

  # Tell browsers whether to use default HTML5 validations (novalidate option).
  # Default is enabled.
  config.browser_validations = false

  # Collection of methods to detect if a file type was given.
  # config.file_methods = [ :mounted_as, :file?, :public_filename ]

  # Custom mappings for input types. This should be a hash containing a regexp
  # to match as key, and the input type that will be used when the field name
  # matches the regexp as value.
  # config.input_mappings = { /count/ => :integer }

  # Default priority for time_zone inputs.
  # config.time_zone_priority = nil

  # Default priority for country inputs.
  # config.country_priority = nil

  # Default size for text inputs.
  # config.default_input_size = 50

  # When false, do not use translations for labels.
  # config.translate_labels = true

  # Automatically discover new inputs in Rails' autoload path.
  # config.inputs_discovery = true

  # Cache SimpleForm inputs discovery
  # config.cache_discovery = !Rails.env.development?
end

module SimpleForm
  module Inputs
    class CollectionInput < Base
      def skip_include_blank?
        true #options.keys.include?(:include_blank) # use blank value only if it was manually added
      end
    end

    class RepeatedPasswordInput < PasswordInput
      def input
        if object.respond_to?(attribute_name)
          input_html_options[:value] = object.send(attribute_name).to_s
        end
        super
      end
    end
  end

  class FormBuilder < ActionView::Helpers::FormBuilder
    def password(attribute_name, options = {}, *args, &block)
      input(attribute_name, options.merge(as: :repeated_password), *args, &block)
    end
  end
end
