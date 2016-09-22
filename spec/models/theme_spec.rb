require 'spec_helper'

describe Theme do
  it { is_expected.to validate_presence_of(:label) }

  describe '#secure_id' do
    context 'id is nil' do
      it 'returns nil' do
        expect(build(:theme).secure_id).to be_nil
      end
    end

    context 'persisted' do
      let (:theme) { insert :theme }

      it 'returns md5 hash for ID' do
        expect(theme.secure_id).to eq Digest::MD5.hexdigest("#{Theme::SALT}-#{theme.id}")
      end
    end
  end
end