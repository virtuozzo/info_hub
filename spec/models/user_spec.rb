require 'spec_helper'

describe User do
  it { is_expected.to have_many(:users_roles) }
  it { is_expected.to have_many(:roles).through(:users_roles) }
end
