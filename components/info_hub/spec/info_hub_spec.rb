require 'info_hub'

describe InfoHub do
  paths = %w( spec/fixtures/component_info_hub.yml spec/fixtures/info_hub.yml spec/fixtures/info_hub.local.yml )
  described_class.info_hub_file_paths.concat(paths)
  described_class.finalize!

  context 'finalized settings' do
    specify 'not finalized' do
      allow(described_class).to receive(:finalized?).and_return false

      expect(described_class).not_to be_finalized
      expect{ described_class.get(:user, :name) }.to raise_error described_class::SettingsNotFinalizedError
    end

    specify 'finalized' do
      expect(described_class).to be_finalized
      expect(described_class.info_hub_file_paths).to be_frozen
      expect{ described_class.get(:user, :name) }.not_to raise_error
    end
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

  context 'work with components info_hub.yml files' do
    specify '#info_hub_file_paths' do
      expect(described_class.info_hub_file_paths).to match_array paths
    end

    it 'loads settings from components info_hub.yml' do
      expect(described_class.get(:component, :name)).to eq 'Component Name'
    end

    it 'loads settings in right order' do
      expect(described_class.get(:user, :name)).to eq 'Pibodi'
      expect(described_class.get(:user, :email)).to eq 'example@mail.com'
      expect(described_class.get(:user, :login)).to eq 'my_login'
      expect(described_class.get(:user, :status, :admin)).to be false
      expect(described_class.get(:user, :status, :logged)).to be false
      expect(described_class.get(:user, :status, :last_login)).to be true
    end
  end
end
