require 'spec_helper'

describe OnApp do
  delegate :configuration, to: :described_class

  describe '.configuration' do
    it 'returns configuration' do
      expect(configuration.to_json).to eq described_class::Configuration.new.to_json
    end
  end
end
