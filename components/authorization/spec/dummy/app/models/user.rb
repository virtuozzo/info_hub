class User < ActiveRecord::Base
  include Permissions::BaseModelMethods
  include Permissions::UserModelMethods.attached_to(:permissions)

  attr_accessible :email

  devise :database_authenticatable

  attr_writer :suspended, :deleted, :active

  def suspended?
    @suspended ||= false
  end

  def deleted?
    @deleted ||= false
  end

  def active?
    @active ||= false
  end

  def user_white_lists
    []
  end

  def permissions
    [OpenStruct.new(identifier: 'users.create')]
  end
end
