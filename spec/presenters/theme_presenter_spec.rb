require 'spec_helper'

describe ThemePresenter do
  let(:presenter) { described_class.new(theme) }
  let(:theme)     { pure :theme, label: 'my theme' }

  describe '#render' do
    let(:mock_file) { double(:file) }

    before do
      allow(mock_file).to receive(:read).and_return 'label: <%= label %>'
      allow(File).to receive(:open).and_yield(mock_file)
    end

    it 'returns erb result' do
      expect(presenter.render).to eq 'label: my theme'
    end
  end

  describe '#generate!' do
    let(:mock_file) { '' }

    before do
      allow(File).to receive(:open).and_yield(mock_file)
      allow(presenter).to receive(:render).and_return 'content'
    end

    it 'generates content to file' do
      presenter.generate!
      expect(mock_file).to eq 'content'
    end
  end

  describe '#stylesheet_url' do
    before { allow(theme).to receive(:secure_id).and_return 'id' }

    it 'returns url to stylesheet' do
      expect(presenter.stylesheet_url).to eq '/themes/id.css'
    end
  end

  describe '#template_path' do
    it 'returns path to template file' do
      expect(presenter.template_path).to eq Core::Engine.root.join('app', 'views', 'presenters', 'theme_presenter.css.erb')
    end
  end
end
