require 'spec_helper'

describe Core::InfoboxHelper, type: :helper do
  let(:user) { pure :user }
  let(:default_infobox_presenter_class) { DefaultInfoboxPresenter }

  before { allow(view).to receive(:current_user).and_return(user) }

  describe '#infobox' do
    it 'should render infobox markup' do
      expect(helper.infobox(title: 'title', description: 'description')).to have_selector('div.infobox') do |scope|
        expect(scope).to have_selector('p', content: 'description')
      end
    end
  end

  describe '#default_infobox_presenter' do
    it 'should return DefaultInfoboxPresenter' do
      expect(helper.default_infobox_presenter).to be_a_kind_of(default_infobox_presenter_class)
    end
  end

  describe '#add_default_infobox' do
    before do
      allow_any_instance_of(default_infobox_presenter_class).to receive(:add).with('title', 'description', true).and_return(true)
    end

    it 'should should proxy method to DefaultInfoboxPresenter' do
      expect(helper.add_default_infobox(title: 'title', description: 'description', skip_title: true)).to be true
    end
  end
end
