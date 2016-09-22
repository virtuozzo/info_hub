require 'spec_helper'

describe Restrictions::Resource do
  describe '#validations' do
    describe 'identifier' do
      let(:restriction_type) { 'by_user_group' }

      it 'is empty' do
        resource = Restrictions::Resource.new(restriction_type: restriction_type)

        expect(resource.save).to be_falsey
        expect(resource.errors).to include :identifier
        expect(resource.errors[:identifier]).to include "can't be blank"
      end

      it 'is not unique' do
        existing_resource = insert :restrictions_resource

        resource = Restrictions::Resource.new(identifier: existing_resource.identifier, restriction_type: restriction_type)

        expect(resource.save).to be_falsey
        expect(resource.errors).to include :identifier
        expect(resource.errors[:identifier]).to include "has already been taken"
      end

      it 'is valid' do
        resource = Restrictions::Resource.new(identifier: 'virtual_machines', restriction_type: restriction_type)

        expect(resource.save).to be true
      end
    end

    describe 'restriction_type' do
      let(:identifier) { 'virtual_machines' }

      it 'is empty' do
        resource = Restrictions::Resource.new(identifier: identifier)

        expect(resource.save).to be_falsey
        expect(resource.errors).to include :restriction_type
        expect(resource.errors[:restriction_type]).to include "can't be blank"
      end

      it 'is not in list' do
        resource = Restrictions::Resource.new(identifier: identifier, restriction_type: 'restiction_type')

        expect(resource.save).to be_falsey
        expect(resource.errors).to include :restriction_type
        expect(resource.errors[:restriction_type]).to include "is not included in the list"
      end

      it 'is valid' do
        resource = Restrictions::Resource.new(identifier: identifier, restriction_type: 'by_user_group')

        expect(resource.save).to be true
      end
    end
  end

  describe '#name' do
    let(:resource) { insert :restrictions_resource, identifier: 'virtual_machines' }

    it 'is valid' do
      expect(resource.name).to eq I18n.t('restrictions.resources.virtual_machines')
    end
  end

  describe '#restriction_name' do
    let(:resource) { insert :restrictions_resource, restriction_type: 'by_user_group' }

    it 'is valid' do
      expect(resource.restriction_name).to eq I18n.t('restrictions.types.by_user_group')
    end
  end

  describe '#label' do
    let(:resource) { insert :restrictions_resource, identifier: 'virtual_machines', restriction_type: 'by_user_group' }

    it 'is valid' do
      label = "#{ I18n.t('restrictions.resources.virtual_machines') } (#{ I18n.t('restrictions.types.by_user_group') })"
      expect(resource.label).to eq label
    end
  end
end