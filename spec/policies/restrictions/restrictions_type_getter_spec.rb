require 'spec_helper'

describe Restrictions::RestrictionTypeGetter do
  describe '.get' do
    let(:user)                  { insert :user }
    let(:role)                  { insert :role }
    let(:restricted_identifier) { 'virtual_machines' }
    let(:restriction_type)      { 'by_user_group' }

    subject { described_class.get(user.id, restricted_identifier) }

    before { insert :users_role, user: user, role: role }

    context 'user w/ one role' do
      context 'w/ restriction' do
        let(:resource) { insert :restrictions_resource, identifier: restricted_identifier, restriction_type: restriction_type }
        let(:set)      { insert :restrictions_set }

        before do
          insert :restrictions_sets_resource, set: set, resource: resource
          insert :restrictions_sets_role, set: set, role: role
        end

        it { should eq Array(restriction_type) }
      end

      context 'w/o restrictions' do
        it { should be_empty }
      end
    end

    context 'user w/ two roles' do
      let(:another_role) { insert :role }

      before { insert :users_role, user: user, role: another_role }

      context 'both w/o restrictions' do
        it { should be_empty }
      end

      context 'one w/ restriction' do
        let(:resource) { insert :restrictions_resource, identifier: restricted_identifier, restriction_type: restriction_type }
        let(:set)      { insert :restrictions_set }

        before do
          insert :restrictions_sets_resource, set: set, resource: resource
          insert :restrictions_sets_role, set: set, role: role
        end

        it { should eq Array(restriction_type) }
      end

      context 'both w/ restrictions' do
        let(:resource)         { insert :restrictions_resource, identifier: restricted_identifier, restriction_type: restriction_type }
        let(:set)              { insert :restrictions_set }
        let(:another_resource) { insert :restrictions_resource, identifier: restricted_identifier, restriction_type: restriction_type }
        let(:another_set)      { insert :restrictions_set }

        before do
          insert :restrictions_sets_resource, set: set, resource: resource
          insert :restrictions_sets_role, set: set, role: role
          insert :restrictions_sets_resource, set: another_set, resource: another_resource
          insert :restrictions_sets_role, set: another_set, role: another_role
        end

        it { should eq Array(restriction_type) }
      end
    end
  end

  describe '#get_identifier' do
    it 'resource is a string' do
      expect(
          described_class.new(1, 'virtual_machines').send(:get_identifier)
      ).to eq 'virtual_machines'
    end

    it 'resource is a symbol' do
      expect(
          described_class.new(1, :virtual_machines).send(:get_identifier)
      ).to eq 'virtual_machines'
    end

    it 'resource is a class' do
      expect(
          described_class.new(1, RolesPermission).send(:get_identifier)
      ).to eq 'roles_permissions'
    end

    it 'resource is unsupported' do
      expect{
        described_class.new(1, {resource: :virtual_machines}).send(:get_identifier)
      }.to raise_exception described_class::UnsupportedResourceType
    end
  end
end
