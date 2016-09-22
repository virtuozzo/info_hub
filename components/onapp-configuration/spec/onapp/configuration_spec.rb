require 'spec_helper'

describe OnApp::Configuration do
  before { allow(OnApp).to receive(:centos) { double(version: 6) } }

  it 'does not return numerical data for non corresponding attributes' do
    subject.app_name = '2'
    expect(subject.app_name).not_to be_kind_of(Fixnum)
  end

  it "does not change non corresponding attributes if their values equals to '1' or true" do
    subject.app_name = '1'
    expect(subject.app_name).to eq('1')
  end

  context '.defaults?' do
    subject { OnApp.configuration.default?(:nfs_root_ip) }
    specify { expect(subject).to be true }

    it 'change default value' do
      described_class.any_instance.stub(:nfs_root_ip => 'custom value')

      expect(subject).to be false
    end
  end

  it '.use?' do
    expected = double('Expected params')
    OnApp.configuration.stub(:foo => expected)
    expect(OnApp.use?(:foo)).to eq(expected)
  end

  context 'read/write' do
    let(:custom_config) { { data_path: '/data', backups_path: '/backups' } }
    let(:path) { '/tmp/onapp.yml.test' }
    let(:defaults) { described_class.defaults }
    let(:configuration_class) { OnApp::Configuration }
    let(:config_file) { configuration_class::FileBackend.new }

    subject { configuration_class.new }

    before { allow(configuration_class).to receive(:config_file_path).and_return path }

    describe '#load_from_file' do
      before { File.write(path, YAML.dump(custom_config)) }

      it 'merges with given config if file exists' do
        expect {
          subject.load_from_file
        }.to change {
          [subject.data_path, subject.backups_path]
        }.from([defaults[:data_path], defaults[:backups_path]])
        .to([custom_config[:data_path], custom_config[:backups_path]])
      end

      it 'does nothing if config file not exists' do
        File.delete(path) if File.file?(path)
        expect {
          subject.load_from_file
        }.not_to change { [subject.data_path, subject.backups_path] }
      end
    end

    describe '#save_to_file' do
      it 'stores data to file' do
        File.write(path, '')

        expect {
          subject.data_path = custom_config[:data_path]
          subject.backups_path = custom_config[:backups_path]
          subject.save_to_file
        }.to change {
          config_file.read
          [config_file.get(:data_path), config_file.get(:backups_path)]
        }.from([nil, nil])
        .to([custom_config[:data_path], custom_config[:backups_path]])
      end
    end
  end

  describe '.update_attributes' do
    let(:conf) { OnApp.configuration.dup }
    let(:attributes) {
      { use_yubikey_login: true, rabbitmq_port: 7777 }
    }

    it 'updates choosen attributes' do
      conf.update_attributes(attributes)

      expect(conf.use_yubikey_login).to be true
      expect(conf.rabbitmq_port).to eq 7777
    end
  end
end