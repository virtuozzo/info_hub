require 'spec_helper'

describe OnApp::CentOSVersion do
  let(:release_string) { double(:release_string) }
  let(:major_version) { 6 }

  subject(:centos_version) { described_class.new }

  before do
    allow(centos_version).to receive(:release_string).and_return(release_string)
    allow(Utils::RedhatRelease).to receive(:major_version).and_return(major_version)
  end

  describe '#version' do
    it 'returns major version' do
      expect(Utils::RedhatRelease).to receive(:major_version).with(release_string)
      centos_version.version
    end
  end

  describe "version's query methods" do
    before { allow(centos_version).to receive(:version).and_return(version) }

    describe '#centos5?' do
      subject { centos_version.centos5? }

      context 'version == 5' do
        let(:version) { 5 }

        it { is_expected.to be true }
      end

      context 'version == 6' do
        let(:version) { 6 }

        it { is_expected.to be false }
      end
    end

    describe '#centos6?' do
      subject { centos_version.centos6? }

      context 'version == 6' do
        let(:version) { 6 }

        it { is_expected.to be true }
      end

      context 'version == 7' do
        let(:version) { 7 }

        it { is_expected.to be false }
      end
    end


    describe '#centos7?' do
      subject { centos_version.centos7? }

      context 'version == 7' do
        let(:version) { 7 }

        it { is_expected.to be true }
      end

      context 'version == 5' do
        let(:version) { 5 }

        it { is_expected.to be false }
      end
    end
  end
end
