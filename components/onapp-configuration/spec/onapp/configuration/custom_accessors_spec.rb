require 'spec_helper'

describe OnApp::Configuration::CustomAccessors do
  let(:klass) { Class.new { extend OnApp::Configuration::CustomAccessors } }

  subject { klass.new }

  describe '.define_numerical_getters' do
    before { klass.define_numerical_getters :numerical_method }

    it 'returns numerical data' do
      subject.instance_variable_set(:@numerical_method, 11.5)

      expect(subject.numerical_method).to eq 11
    end
  end

  describe '.define_boolean_setters' do
    before { klass.define_boolean_setters :boolean_method }

    it 'returns true for 1' do
      subject.boolean_method = 1

      expect(subject.instance_variable_get(:@boolean_method)).to be true
    end

    it 'returns false for 0' do
      subject.boolean_method = 0

      expect(subject.instance_variable_get(:@boolean_method)).to be false
    end

    it "returns true for 'true'" do
      subject.boolean_method = 'true'

      expect(subject.instance_variable_get(:@boolean_method)).to be true
    end
  end
end

