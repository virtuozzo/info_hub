require 'spec_helper'

describe ViewPresenter, type: :presenter do
  let(:view)      { double(:view) }
  let(:presenter) { described_class.new(view) }

  describe '#method_missing' do
    it 'should proxy missing methods to view' do
      expect(view).to receive(:test_method).with(1).and_return(true)

      expect(presenter.test_method(1)).to be true
    end
  end
end
