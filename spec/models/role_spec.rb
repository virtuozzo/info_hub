require 'spec_helper'

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
end
