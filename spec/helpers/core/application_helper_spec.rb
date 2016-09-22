require 'spec_helper'

describe Core::ApplicationHelper, type: :helper do
  delegate :render_page_title, :render_custom_css_link, :application_title, to: :helper

  describe '#render_page_title' do
    it 'returns page title with additional text' do
      assign(:page_title_text, 'global_title')

      expect(render_page_title('additional_title')).to match(/additional_title.*global_title/)
    end

    it 'returns page title without additional text' do
      assign(:page_title_text, 'global_title')

      expect(render_page_title).to match(/global_title/)
      expect(render_page_title).not_to match(/additional_title/)
    end

    it 'escapes dash' do
      assign(:page_title_text, 'text-with-dashes')

      expect(render_page_title('more-dashes ')).to eq 'more&#45;dashes text&#45;with&#45;dashes'
    end
  end

  describe '#render_custom_css_link' do
    let(:current_user) { build :user }

    before do
      allow(helper).to receive(:current_user).and_return current_user
      allow(current_user).to receive(:theme).and_return theme
    end

    context 'current user has theme' do
      let(:theme) { insert :theme }

      it 'renders link tag' do
        expect(render_custom_css_link).to have_selector("link[href='/themes/#{theme.secure_id}.css']")
      end
    end

    context 'current user does not have theme' do
      let(:theme) { nil }

      it 'returns nil' do
        expect(render_custom_css_link).to be_nil
      end
    end
  end

  describe '#application_title' do
    before { allow(helper).to receive(:current_user).and_return current_user }

    context 'when current user exists' do
      let(:current_user) { pure :user }
      before { allow(current_user).to receive(:theme_application_title).and_return theme_application_title }

      context 'when current user has theme_application_title' do
        let(:theme_application_title) { 'theme' }

        it 'returns it' do
          expect(application_title).to eq 'theme'
        end
      end

      context 'when current user does not have theme_application_title' do
        let(:theme_application_title) { '' }

        it 'returns title from application settings' do
          allow(OnApp.configuration).to receive(:app_name).and_return 'application'

          expect(application_title).to eq 'application'
        end
      end
    end

    context 'when current user does not exist' do
      let(:current_user) { nil }

      it 'returns title from application settings' do
        allow(OnApp.configuration).to receive(:app_name).and_return 'application'

        expect(application_title).to eq 'application'
      end
    end
  end
end