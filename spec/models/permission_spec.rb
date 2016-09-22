require 'spec_helper'

describe Permission do
  it { expect(subject).to have_many :roles }
  it { expect(subject).to have_many(:roles_permissions).dependent(:destroy) }

  it { expect(subject).to have_readonly_attribute :identifier }

  it { expect(subject).to validate_presence_of :identifier }

  context 'uniqueness' do
    let(:permission) { create :permission }
    let(:not_unique_permission) { build :permission,
                                        identifier: permission.identifier }
    let(:uniqe_permission) { build :permission, identifier: 'i.am.unique' }

    it 'validates uniqueness of identifier' do
      expect(not_unique_permission).not_to be_valid
      expect(uniqe_permission).to be_valid
    end
  end

  describe '.add_permission' do
    subject(:add_permission) {
      described_class.add_permission(identifier: 'new.ident')
    }

    it 'should add new permission' do
      expect { add_permission }.to change{ described_class.count }.by(1)
    end

    it 'should not add new permission if indentifier not uniq' do
      create :permission, identifier: 'new.ident'

      expect { add_permission }.to_not change{ described_class.count }
    end

    context 'with roles option' do
      let(:permission) {
        described_class.add_permission(identifier: 'new.ident',
                                       roles: [role.identifier])
      }
      let(:role) { create :role }

      it 'adds roles to permission' do
        expect(permission.roles).to eq [role]
        expect(role.permissions).to eq [permission]
      end

      context 'roles = []' do
        it 'does not change existing roles' do
          expect(permission.roles).to eq [role]
          expect { described_class.add_permission(identifier: 'unique.ident',
                                                  roles: []) }.
            to change { described_class.count }.by(1)
          expect(permission.roles).to eq [role]
        end
      end
    end

    context 'incorrect values' do
      it 'should raise and exception if identifier is empty' do
        expect {
          described_class.add_permission(identifier: '')
        }.to raise_error ActiveRecord::RecordInvalid
      end

      it 'should not raise and exception if roles are empty' do
        expect {
          described_class.add_permission(identifier: 'new.ident',
                                         roles: [])
        }.not_to raise_error

        expect {
          described_class.add_permission(identifier: 'new.ident',
                                         roles: nil)
        }.not_to raise_error
      end
    end
  end
end
