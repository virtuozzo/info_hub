require 'spec_helper'

describe User do
  let(:user) { pure :user }

  describe '#display_infoboxes' do
    it 'should return true if infoboxes are enabled' do
      user.display_infoboxes = true
      expect(user.display_infoboxes).to be true
    end

    it 'should return false if infoboxes are disabled' do
      user.display_infoboxes = false
      expect(user.display_infoboxes).to be_falsey
    end

    it 'should return true by default' do
      expect(user.display_infoboxes).to be true
    end
  end

  describe '#display_infoboxes=' do
    it 'should be able to change infobox status' do
      user.display_infoboxes = true
      expect(user.display_infoboxes).to be true
      user.display_infoboxes = false
      expect(user.display_infoboxes).to be_falsey
    end
  end

  describe '#hidden_infoboxes' do
    it 'should return hidden infobox collection' do
      expect(user.hidden_infoboxes).to eq []
      user.hide_infobox('aaa')
      user.hide_infobox('bbb')
      expect(user.hidden_infoboxes).to eq %w(aaa bbb)
    end
  end

  describe '#hide_infobox' do
    it 'should add infobox to hidden list' do
      user.hide_infobox('aaa')
      user.hide_infobox('bbb')
      expect(user.hidden_infoboxes).to eq %w(aaa bbb)
    end
  end

  describe '#restore_infobox' do
    it 'should remove infobox from hidden list' do
      user.hide_infobox('aaa')
      user.hide_infobox('bbb')
      user.restore_infobox('aaa')
      user.restore_infobox('ccc')
      expect(user.hidden_infoboxes).to eq %w(bbb)
    end
  end

  describe '#hidden_infobox?' do
    describe 'displaying infoboxes are enabled' do
      before { user.display_infoboxes = true }

      it 'should return false if infobox is not in the hidden list' do
expect(        user).not_to be_hidden_infobox('aaa')
      end

      it 'should return true if infobox is in the hidden list' do
        user.hide_infobox('aaa')
        expect(user).to be_hidden_infobox('aaa')
      end
    end

    describe 'displaying infoboxes are disabled' do
      before { user.display_infoboxes = false }

      it 'should return true if infobox is in the hidden list' do
        user.hide_infobox('aaa')
        expect(user).to be_hidden_infobox('aaa')
      end

      it 'should return true if infobox is not in the hidden list' do
        expect(user).to be_hidden_infobox('bbb')
      end
    end
  end
end