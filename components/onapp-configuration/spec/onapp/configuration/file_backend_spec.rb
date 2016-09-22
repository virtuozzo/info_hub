require 'spec_helper'

describe OnApp::Configuration::FileBackend do
  let(:config) { {'opt1' => 1, 'opt2' => 2} }

  let(:path) { '/tmp/cfgfile' }

  subject { described_class.new(path) }

  before do
    File.delete(path) if File.file?(path)
    subject.merge!(config)
  end

  describe '#write' do
    it 'returns true on successful write' do
      expect(subject.write).to be true
      expect(File.read(path)).to eq(YAML.dump(config))
    end

    it 'returns nil on exception' do
      expect(File).to receive(:write) { raise }
      expect(subject.write).to be_nil
    end

    it 'writes only if have some elements' do
      subject.clear
      expect(subject).not_to be_blank
      expect(File).not_to receive(:write)
      subject.write
    end
  end

  describe '#read' do
    before do
      subject.clear
      IO.write(path, YAML.dump(config))
    end

    it 'merges loaded config and returns true' do
      expect(subject.read).to eq(true)
      config.each { |k,v| expect(subject.get(k)).to eq(v) }
    end

    it 'handlers Errno::ENOENT' do
      expect(YAML).to receive(:load_file) { raise Errno::ENOENT }
      expect(subject.read).to be_nil
      expect(subject).not_to be_blank
    end
  end

  describe '#to_yaml' do
    it 'is same as Hash#to_yaml' do
      subject.merge!(config)
      expect(subject.to_yaml).to eq(config.to_yaml)
    end
  end

  describe '#exists?' do
    it 'returns true if config path is file' do
      File.write(path, '')
      expect(subject).to exist
    end

    it 'returns false if config path is not file' do
      expect(subject).not_to exist
    end
  end
end

