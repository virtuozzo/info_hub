require 'spec_helper'

describe OnApp::Configuration do
  let(:config_file) { described_class::FileBackend.new }

  before { allow(OnApp).to receive(:centos) { double(version: 6) } }

  it 'does not return numerical data for non corresponding attributes' do
    subject.app_name = '2'
    expect(subject.app_name).not_to be_kind_of(Fixnum)
  end

  it "does not change non corresponding attributes if their values equals to '1' or true" do
    subject.app_name = '1'
    expect(subject.app_name).to eq('1')
  end

  context '#default?' do
    subject { OnApp.configuration.default?(:system_email) }

    specify { expect(subject).to be true }

    it 'change default value' do
      allow_any_instance_of(described_class).to receive(:system_email).and_return 'system_email@onapp.com'

      expect(subject).to be false
    end
  end

  it '.use?' do
    expected = double('Expected params')
    OnApp.configuration.stub(:foo => expected)
    expect(OnApp.use?(:foo)).to eq(expected)
  end

  context 'read/write' do
    let(:custom_config) { { system_email: 'system_email@onapp.com', system_host: '192.12.1.1' } }
    let(:path) { '/tmp/onapp.yml.test' }
    let(:defaults) { described_class.defaults }

    before { allow(described_class).to receive(:config_file_path).and_return path }

    describe '#load_from_file' do
      before { File.write(path, YAML.dump(custom_config)) }

      it 'merges with given config if file exists' do
        expect {
          subject.load_from_file
        }.to change {
          [subject.system_email, subject.system_host]
        }.from([defaults[:system_email], defaults[:system_host]])
        .to([custom_config[:system_email], custom_config[:system_host]])
      end

      it 'does nothing if config file not exists' do
        File.delete(path) if File.file?(path)
        expect {
          subject.load_from_file
        }.not_to change { [subject.system_email, subject.system_host] }
      end
    end

    describe '#save_to_file' do
      it 'stores data to file' do
        File.write(path, '')

        expect {
          subject.system_email = custom_config[:system_email]
          subject.system_host = custom_config[:system_host]
          subject.save_to_file
        }.to change {
          config_file.read
          [config_file.get(:system_email), config_file.get(:system_host)]
        }.from([nil, nil])
        .to([custom_config[:system_email], custom_config[:system_host]])
      end
    end
  end

  describe '.update_attributes' do
    let(:conf) { OnApp.configuration.dup }
    let(:attributes) { { system_email: 'new_system_email@onapp.com', system_host: '243.12.33.1' } }

    it 'updates choosen attributes' do
      conf.update_attributes(attributes)

      expect(conf.system_email).to eq 'new_system_email@onapp.com'
      expect(conf.system_host).to eq '243.12.33.1'
    end
  end

  describe '#config_key_warning' do
    it 'returns file path' do
      expect(subject.config_key_warning(:some_key)).to match(/on_app.yml/)
    end
  end

  describe '#config_file_warning' do
    it 'returns file path' do
      expect(subject.config_file_warning).to match(/on_app.yml/)
    end
  end
end
