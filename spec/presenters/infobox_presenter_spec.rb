require 'spec_helper'

describe InfoboxPresenter, type: :presenter do
  let(:infobox) { described_class.new(view) }
  let(:user)    { pure :user }

  before { allow(view).to receive(:current_user).and_return(user) }

  describe '#info' do
    it 'should return hash' do
      expect(infobox.info).to be_a_kind_of(Hash)
    end
  end

  describe '#add' do
    before do
      infobox.add('title', 'content 1', true)
    end

    it 'should create new content' do
      expect(infobox.info['title']).to eq({ content: 'content 1', skip_title: true })
    end

    it 'should merge contents if titles are equal' do
      infobox.add('title', 'content 2', false)
      expect(infobox.info['title']).to eq({ content: 'content 1 content 2', skip_title: false })
    end
  end

  describe '#delete' do
    before do
      infobox.add('title1', 'content 1')
      infobox.add('title2', 'content 2')
    end

    it 'should remove by title' do
      infobox.delete('title1')
      expect(infobox.info).to_not have_key('title1')
      expect(infobox.info).to have_key('title2')
    end
  end

  describe '#replace_title' do
    before do
      infobox.add('title', 'content')
    end

    it 'should replace title' do
      infobox.replace_title('title', 'new title')
      expect(infobox.info['new title']).to eq({ content: 'content', skip_title: false })
    end
  end

  describe '#replace_content' do
    before do
      infobox.add('title', 'content')
    end

    it 'should replace content' do
      infobox.replace_content('title', 'new content')
      expect(infobox.info['title']).to eq({ content: 'new content', skip_title: false })
    end
  end

  describe '#render' do
    describe 'with title' do
      before do
        infobox.add('title 1', 'content 1')
      end

      it 'should render content and title' do
        expect(infobox.render).to match /title 1/
        expect(infobox.render).to match /content 1/
      end

      it 'should return html_safe string' do
        expect(infobox.render).to be_html_safe
      end
    end

    describe 'skip title' do
      before do
        infobox.add('title', 'content 1', skip_title: true)
      end

      it 'should render content only' do
        expect(infobox.render).to_not match /title 1/
        expect(infobox.render).to match /content 1/
      end

      it 'should return html_safe string' do
        expect(infobox.render).to be_html_safe
      end
    end

    describe 'hidden for current user' do
      before { allow(user).to receive(:hidden_infobox?).and_return(true) }

      it 'should render blank string' do
        expect(infobox.render).to eq ''
      end
    end
  end
end