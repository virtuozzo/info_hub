require 'spec_helper'

describe Core do
  describe '.partials' do
    specify { expect(described_class.partials).to eq({}) }
  end

  describe '.additional_helpers_paths' do
    specify { expect(described_class.additional_helpers_paths).to eq [] }
  end

  describe '.devise_controllers' do
    specify { expect(described_class.devise_controllers).to eq(sessions: 'core/users/sessions') }
  end

  describe '.main_navigation_group_methods' do
    specify { expect(described_class.main_navigation_group_methods).to contain_exactly(:core_main_navigation_groups) }
  end

  describe '.concerns' do
    specify { expect(described_class.concerns).to eq(user: [:theme]) }
  end

  describe '.extensions' do
    specify { expect(described_class.extensions).to eq({}) }
  end

  describe '.add_concerns' do
    before { allow(described_class).to receive(:concerns).and_return concerns }

    context 'concerns are empty' do
      let(:concerns) { {} }

      it 'adds new array if no key exists' do
        described_class.add_concerns(foo: [:bar])

        expect(described_class.concerns).to eq(foo: [:bar])
      end
    end

    context 'concerns present' do
      let(:concerns) { { foo: [:baz] } }

      it 'adds new element to existing array' do
        described_class.add_concerns(foo: [:bar])

        expect(described_class.concerns).to eq(foo: %i( baz bar ))
      end
    end
  end

  describe '.add_extensions' do
    before { allow(described_class).to receive(:extensions).and_return extensions }

    context 'extensions are empty' do
      let(:extensions) { {} }

      it 'adds new array if no key exists' do
        described_class.add_extensions(foo: 'SomeModule')

        expect(described_class.extensions).to eq(foo: ['SomeModule'])
      end
    end

    context 'extensions present' do
      let(:extensions) { { foo: ['OtherModule'] } }

      it 'adds new element to existing array' do
        described_class.add_extensions(foo: 'SomeModule')

        expect(described_class.extensions).to eq(foo: %w( OtherModule SomeModule ))
      end
    end
  end

  describe '.constantized_extensions' do
    delegate :constantized_extensions, to: :described_class

    before { allow(described_class).to receive(:extensions).and_return extensions }

    context 'extensions are empty' do
      let(:extensions) { {} }

      it 'returns an empty array' do
        expect(constantized_extensions(:foo)).to match_array []
      end
    end

    context 'extensions present' do
      let(:some_module) { Module.new }
      let(:some_module_name) { double(constantize: some_module) }
      let(:extensions) { { foo: [some_module_name] } }

      it 'returns array of modules' do
        expect(constantized_extensions(:foo)).to contain_exactly(some_module)
      end
    end
  end
end
