require 'spec_helper'

describe User do
  let(:user) { pure :user }

  shared_examples_for 'image url' do
    subject { user.send("theme_#{theme_method}") }

    context 'when theme exists' do
      before { allow(user).to receive(:theme).and_return double(theme_method => '/image') }

      it { should == '/image' }
    end

    context 'when theme does not exist' do
      before { allow(user).to receive(:theme).and_return nil }

      it { should be_nil }
    end
  end

  shared_examples_for 'text attribute' do
    subject { user.send("theme_#{theme_method}") }

    context 'when theme exists' do
      before { allow(user).to receive(:theme).and_return double(theme_method => 'text') }

      it { should == 'text' }
    end

    context 'when theme does not exist' do
      before { allow(user).to receive(:theme).and_return nil }

      it { should == '' }
    end
  end

  shared_examples_for 'boolean attribute' do
    subject { user.send("theme_#{theme_method}") }

    context 'when theme exists' do
      before { allow(user).to receive(:theme).and_return double(theme_method => true) }

      it { should be true }
    end

    context 'when theme does not exist' do
      before { allow(user).to receive(:theme).and_return nil }

      it { should be_nil }
    end
  end

  describe '#theme_logo_url' do
    it_behaves_like 'image url' do
      let(:theme_method) { :logo_url }
    end
  end

  describe '#theme_favicon_url' do
    it_behaves_like 'image url' do
      let(:theme_method) { :favicon_url }
    end
  end

  describe '#theme_wrapper_top_background_image_url' do
    it_behaves_like 'image url' do
      let(:theme_method) { :wrapper_top_background_image_url }
    end
  end

  describe '#theme_wrapper_bottom_background_image_url' do
    it_behaves_like 'image url' do
      let(:theme_method) { :wrapper_bottom_background_image_url }
    end
  end

  describe '#theme_body_background_image_url' do
    it_behaves_like 'image url' do
      let(:theme_method) { :body_background_image_url }
    end
  end

  describe '#label' do
    it_behaves_like 'text attribute' do
      let(:theme_method) { :label }
    end
  end

  describe '#theme_application_title' do
    it_behaves_like 'text attribute' do
      let(:theme_method) { :application_title }
    end
  end

  describe '#theme_powered_by_url' do
    it_behaves_like 'text attribute' do
      let(:theme_method) { :powered_by_url }
    end
  end

  describe '#theme_powered_by_link_title' do
    it_behaves_like 'text attribute' do
      let(:theme_method) { :powered_by_link_title }
    end
  end

  describe '#theme_powered_by_color' do
    it_behaves_like 'text attribute' do
      let(:theme_method) { :powered_by_color }
    end
  end

  describe '#theme_powered_by_text' do
    it_behaves_like 'text attribute' do
      let(:theme_method) { :powered_by_text }
    end
  end

  describe '#theme_wrapper_background_color' do
    it_behaves_like 'text attribute' do
      let(:theme_method) { :wrapper_background_color }
    end
  end

  describe '#theme_body_background_color' do
    it_behaves_like 'text attribute' do
      let(:theme_method) { :body_background_color }
    end
  end

  describe '#theme_html_header' do
    it_behaves_like 'text attribute' do
      let(:theme_method) { :html_header }
    end
  end

  describe '#theme_html_footer' do
    it_behaves_like 'text attribute' do
      let(:theme_method) { :html_footer }
    end
  end

  describe '#theme_powered_by_hide' do
    it_behaves_like 'boolean attribute' do
      let(:theme_method) { :powered_by_hide }
    end
  end

  describe '#theme_disable_logo' do
    it_behaves_like 'boolean attribute' do
      let(:theme_method) { :disable_logo }
    end
  end

  describe '#theme_disable_favicon' do
    it_behaves_like 'boolean attribute' do
      let(:theme_method) { :disable_favicon }
    end
  end

  describe '#theme_disable_wrapper_top_background_image' do
    it_behaves_like 'boolean attribute' do
      let(:theme_method) { :disable_wrapper_top_background_image }
    end
  end

  describe '#theme_disable_wrapper_bottom_background_image' do
    it_behaves_like 'boolean attribute' do
      let(:theme_method) { :disable_wrapper_bottom_background_image }
    end
  end

  describe '#theme_disable_body_background_image' do
    it_behaves_like 'boolean attribute' do
      let(:theme_method) { :disable_body_background_image }
    end
  end
end