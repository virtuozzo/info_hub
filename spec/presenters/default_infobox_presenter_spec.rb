require 'spec_helper'

describe DefaultInfoboxPresenter, type: :presenter do
  let(:infobox) { described_class.new(view) }

  before do
    allow(view).to receive(:current_user).and_return(pure :user)
    allow(view).to receive(:controller_path).and_return('virtual_machines')
  end

  describe '#render' do
    describe 'exclude default infobox' do
      before { infobox.exclude_default = true }

      it 'should not render default infobox' do
        expect(infobox.render).to eq ''
      end
    end

    describe 'include default infobox' do
      before do
        allow(view).to receive(:action_name).and_return :index
      end

      it 'should render with default infobox' do
        expect(infobox.render).to match /infobox/
      end
    end
  end
end