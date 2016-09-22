require 'spec_helper'

describe Restrictions::Set do
  describe '#validations' do
    describe 'label' do
      let(:set) { insert :restrictions_set }

      it 'is empty' do
        new_set = Restrictions::Set.new

        expect(new_set.save).to be_falsey
        expect(new_set.errors).to include :label
        expect(new_set.errors[:label]).to include "can't be blank"
      end

      it 'is not unique' do
        new_set = Restrictions::Set.new(label: set.label)

        expect(new_set.save).to be_falsey
        expect(new_set.errors).to include :label
        expect(new_set.errors[:label]).to include "has already been taken"
      end

      it 'is valid' do
        new_set = Restrictions::Set.new(label: 'label')

        expect(new_set.save).to be true
      end
    end

    describe 'identifier' do
      let(:set)   { insert :restrictions_set }
      let(:label) { 'label' }

      it 'is empty' do
        new_set = Restrictions::Set.new(label: label)

        expect(new_set.save).to be true
      end

      it 'is valid' do
        new_set = Restrictions::Set.new(label: label, identifier: 'identifier')

        expect(new_set.save).to be true
      end

      it 'is not unique' do
        new_set = Restrictions::Set.new(label: label, identifier: set.identifier)

        expect(new_set.save).to be_falsey
        expect(new_set.errors).to include :identifier
        expect(new_set.errors[:identifier]).to include "has already been taken"
      end
    end
  end
end