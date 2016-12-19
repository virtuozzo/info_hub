require 'spec_helper'

describe BaseSerializer do
  let(:target) { double }
  let(:serializer) { described_class.new(target) }

  describe '#serialize' do
    it 'returns an empty hash' do
      expect { serializer.serialize }.to raise_error(NoMethodError)
    end
  end

  describe '#==' do
    let(:other_serializer) { described_class.new(other_target) }

    context 'targets are equal' do
      let(:other_target) { target }

      it 'is equal' do
        expect(serializer).to eq other_serializer
      end
    end

    context 'target are not equal' do
      let(:other_target) { double }

      it 'is not equal' do
        expect(serializer).not_to eq other_serializer
      end
    end
  end
end