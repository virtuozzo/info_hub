module Core
  module SpecHelpers
    module Api
      def xml_validation(response, model, fields=[], ignore_fields=[], singular: nil)
        content = response.body
        singular ||= ActiveSupport::Inflector.underscore(model.to_s).tr('/', '_')
        plural = singular.pluralize
        fields = fields.empty? ? fields_for(model) : fields
        expect(content).to have_selector("#{plural} > #{singular}")
        fields.each do |field|
          next if ignore_fields.include?(field.to_sym)
          expect(content).to have_selector([singular, field.to_s].join(">"))
        end
      end

      def json_validation(response, model, fields=[], ignore_fields=[], root_key: nil)
        json = ActiveSupport::JSON.decode(response.body).first
        root_key ||= ActiveSupport::Inflector.underscore(model.to_s).tr('/', '_')
        expect(json.key?(root_key)).to be true
        fields = fields.empty? ? fields_for(model) : fields
        fields.each do |field|
          next if ignore_fields.include?(field.to_sym)
          expect(json[root_key].key?(field.to_s)).to be true
        end
      end

      # additional_fields - array of additional fields that should be on model
      def xml_model_validation(response, model, fields=[], additional_fields = [], singular: nil)
        content = response.body
        singular ||= ActiveSupport::Inflector.underscore(model.to_s).tr('/', '_')
        fields = fields.empty? ? fields_for(model) : fields
        fields += additional_fields unless additional_fields.empty?
        expect(content).to have_selector(singular)
        fields.each do |field|
          expect(content).to have_selector([singular, field.to_s].join(">"))
        end
      end

      # additional_fields - array of additional fields that should be on model
      def json_model_validation(response, model, fields=[], additional_fields = [], root_key: nil)
        json = ActiveSupport::JSON.decode(response.body)
        root_key ||= ActiveSupport::Inflector.underscore(model.to_s).tr('/', '_')
        fields = fields.empty? ? fields_for(model) : fields
        fields += additional_fields unless additional_fields.empty?
        fields.each do |field|
          expect(json[root_key].key?(field.to_s)).to be true
        end
      end

      def fields_for(model)
        fields = model.column_names.reject{ |field| field.in?(['type', 'target_type']) }
        fields += model::API_METHODS.map(&:to_s) if defined?(model::API_METHODS)
        fields -= model::API_EXCEPT.map(&:to_s) if defined?(model::API_EXCEPT)
        fields
      end
    end
  end
end

RSpec.configure do |config|
  config.include Core::SpecHelpers::Api, api_helper: true, type: :controller
end
