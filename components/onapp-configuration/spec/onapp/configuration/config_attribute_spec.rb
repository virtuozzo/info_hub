require 'spec_helper'

describe OnApp::Configuration do
  describe '.config_attribute' do
    let(:klass) do
      Class.new(described_class) do
        def self.model_name
          ActiveModel::Name.new(self, nil, 'temp')
        end
      end
    end
    let(:configuration_class) { OnApp::Configuration }
    let(:conf) { klass.new }
    let(:presence_error) { [I18n.t('errors.messages.blank')] }
    let(:config_file) { configuration_class::FileBackend.new }
    let(:validation_errors) { [I18n.t('errors.messages.too_long', count: 60), I18n.t('errors.messages.not_a_number')] }

    context 'setter' do
      specify do
        klass.config_attribute :attribute, getter: :numerical

        expect(conf.attribute).to eq 0

        conf.attribute = 12.34

        expect(conf.attribute).to eq 12
      end

      it 'does not create a setter if setter: false' do
        klass.config_attribute :attribute, setter: false

        expect { conf.attribute = 2 }.to raise_error NoMethodError
      end
    end

    context 'getter' do
      specify do
        klass.config_attribute :attribute, setter: :boolean

        conf.attribute = 1

        expect(conf.attribute).to be true
      end

      it 'does not create a getter if getter: false' do
        klass.config_attribute :attribute, getter: false

        expect { conf.attribute }.to raise_error NoMethodError
      end
    end

    context 'default values' do
      it 'adds attributes to default_values' do
        klass.config_attribute :attribute, default: 12

        expect(conf.attribute).to eq 12

        conf.attribute = 13

        expect(conf.attribute).to eq 13
      end

      it 'add default: false value' do
        klass.config_attribute :attribute, default: false

        expect(conf.attribute).to be false
      end
    end

    context 'save_to_file' do
      it 'saves attribute with value to file' do
        klass.config_attribute :attribute, save_to_file: true

        conf.attribute = 123
        conf.save_to_file
        config_file.read

        expect(config_file.get(:attribute)).to eq 123
      end
    end

    context 'presence' do
      it 'with not valid values' do
        klass.config_attribute :attribute, presence: true

        expect(conf).not_to be_valid
        expect(conf.errors.messages[:attribute]).to eq presence_error
      end

      it 'with valid values' do
        klass.config_attribute :attribute, presence: true

        conf.attribute = 123

        expect(conf.errors.messages[:attribute]).not_to eq presence_error
      end
    end

    context 'validations' do
      it 'validates with invalid values' do
        klass.config_attribute :attribute, length: { maximum: 60 }, numericality: true

        conf.attribute = 'a' * 61

        expect(conf).not_to be_valid
        expect(conf.errors.messages[:attribute]).to eq validation_errors
      end
    end

    context 'accept lambdas as a default value' do
      specify do
        klass.config_attribute :attribute, default: -> { configuration_class.rails_root.join('log') }

        allow(configuration_class).to receive(:rails_root).and_return Pathname.new('/blah_blah')

        expect(conf.attribute.to_s).to eq '/blah_blah/log'
      end
    end

    describe '.processed_defaults' do
      it 'executes lambdas' do
        klass.config_attribute :attribute, default: -> { 'some_text' }, save_to_file: false

        expect(klass.processed_defaults.fetch(:attribute)).to eq 'some_text'
      end
    end

    describe '.ignored_save_to_file_defaults' do
      it 'returns values of save to file attributes as nils' do
        klass.config_attribute :attribute, default: 1, save_to_file: true

        expect(klass.ignored_save_to_file_defaults.fetch(:attribute)).to be_nil
      end

      it 'does not modify values of attributes that are not mean to be saved to file' do
        klass.config_attribute :attribute, default: 1, save_to_file: false

        expect(klass.ignored_save_to_file_defaults.fetch(:attribute)).to eq 1
      end

      it 'executes lambdas' do
        klass.config_attribute :attribute, default: -> { 'some_text' }, save_to_file: false

        expect(klass.ignored_save_to_file_defaults.fetch(:attribute)).to eq 'some_text'
      end
    end
  end
end
