require 'spec_helper'

describe Restrictions::SetsRole do
  let(:set)  { insert :restrictions_set }
  let(:role) { insert :role}

  describe '#validations' do
    describe 'set_id' do
      it 'is empty' do
        sets_resource = Restrictions::SetsRole.new(role: role)

        expect(sets_resource.save).to be_falsey
        expect(sets_resource.errors).to include :set_id
        expect(sets_resource.errors[:set_id]).to include "can't be blank"
      end

      it 'is valid' do
        sets_resource = Restrictions::SetsRole.new(role: role, set: set)

        expect(sets_resource.save).to be true
      end
    end

    describe 'role_id' do
      it 'is empty' do
        sets_resource = Restrictions::SetsRole.new(set: set)

        expect(sets_resource.save).to be_falsey
        expect(sets_resource.errors).to include :role_id
        expect(sets_resource.errors[:role_id]).to include "can't be blank"
      end

      it 'is not uniq' do
        insert :restrictions_sets_role, set: set, role: role

        sets_resource = Restrictions::SetsRole.new(set: set, role: role)

        expect(sets_resource.save).to be_falsey
        expect(sets_resource.errors).to include :role_id
        expect(sets_resource.errors[:role_id]).to include "has already been taken"
      end

      it 'is valid' do
        sets_resource = Restrictions::SetsRole.new(role: role, set: set)

        expect(sets_resource.save).to be true
      end
    end
  end
end