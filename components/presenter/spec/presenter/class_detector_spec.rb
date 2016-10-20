require 'active_support/all'
require 'presenter/class_detector'

describe Presenter::ClassDetector do
  class Spec; end
  class SpecPresenter; end
  class CustomSpecPresenter; end

  describe '.presenter_class' do
    subject { described_class.presenter_class(object, klass) }

    context 'without name' do
      let(:object) { Spec.new }
      let(:klass) { nil }

      it { is_expected.to eq SpecPresenter }
    end

    context 'with name' do
      let(:object) { Spec.new }
      let(:klass) { CustomSpecPresenter }

      it { is_expected.to eq CustomSpecPresenter }
    end
  end
end
