require 'info_hub'
require 'yaml'

describe InfoHub do
  before do
    described_class.default_file_path = 'spec/fixtures/info_hub.yml'
    described_class.local_file_path   = 'spec/fixtures/info_hub.local.yml'
  end

  context '.get' do
    specify 'key exists' do
      expect(described_class.get(:user, :age)).to eq 20
    end

    specify 'key reassigned in a user file' do
      expect(described_class.get(:user, :name)).to eq 'Pibodi'
      expect(described_class.get(:user, :age)).to eq 20
    end

    specify 'key not exist' do
      expect { described_class.get(:user, :address) }.to raise_error described_class::KeyNotFoundError
    end
  end
end
