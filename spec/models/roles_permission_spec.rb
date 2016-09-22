require 'spec_helper'

describe RolesPermission do
  it { is_expected.to validate_presence_of(:role_id) }
  it { is_expected.to validate_presence_of(:permission_id) }
end
