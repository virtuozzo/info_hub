require 'spec_helper'

describe Restrictions::SetsResource do
  let(:set)      { insert :restrictions_set }
  let(:resource) { insert :restrictions_resource }

  describe '#validations' do
    describe 'resource_id' do

      it 'is not uniq' do
        insert :restrictions_sets_resource, set: set, resource: resource

        sets_resource = Restrictions::SetsResource.new(set: set, resource: resource)

        expect(sets_resource.save).to be_falsey
        expect(sets_resource.errors).to include :resource_id
        expect(sets_resource.errors[:resource_id]).to include "has already been taken"
      end

      it 'is valid' do
        sets_resource = Restrictions::SetsResource.new(resource: resource, set: set)

        expect(sets_resource.save).to be true
      end
    end
  end
end
