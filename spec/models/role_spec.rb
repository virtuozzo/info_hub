require 'spec_helper'
require 'shoulda/matchers'

describe Role do
  it 'identifier is redable attribute' do
    role = build :role, label: 'newlabel'

    expect(role.save).to be true
    expect(role.identifier).not_to be_blank
    role.identifier = 'newident'
    expect(role.save).to be true
    role.reload
    expect(role.identifier).to_not eq('newident')
  end

  describe 'validations' do
    let(:role) { build :role }

    it { is_expected.to validate_presence_of(:label) }

    it "is valid when attributes are present" do
      role.attributes = { label: "label" }

      expect(role).to be_valid
    end

    it 'validates label uniqueness' do
      role = build :role, label: 'label'
      role.save
      role2 = build :role, label: 'label'
      expect(role2).to be_invalid
    end
  end

  describe '#can_be_deleted?' do
    subject { role.can_be_deleted? }

    context 'when role is a system role' do
      let(:role) { insert :role, system: true }

      it { is_expected.to be(false) }

      it 'adds validation error' do
        subject
        error = I18n.t('activerecord.errors.models.role.attributes.base.cannot_delete_system_role')
        expect(role.errors[:base]).to include(error)
      end
    end

    context 'when role is assigned to some users' do
      let(:role) { insert :role }

      before do
        user = insert :user
        user.roles << role
      end

      it { is_expected.to be(false) }

      it 'adds validation error' do
        subject
        error = I18n.t('activerecord.errors.models.role.attributes.base.cannot_delete_assigned_role')
        expect(role.errors[:base]).to include(error)
      end
    end

    context 'when role is not a system role and is not assigned to any users' do
      let(:role) { insert :role }

      it { is_expected.to be(true) }

      it 'doesn not add any validation errors' do
        subject
        expect(role.errors).to be_empty
      end
    end
  end
end
