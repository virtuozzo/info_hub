class User < ActiveRecord::Base
  include Permissions::BaseModelMethods
  include Permissions::UserModelMethods.attached_to(:permissions)

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
    PermissionStubbedCollection.new([OpenStruct.new(identifier: 'users.create')])
  end

  class PermissionStubbedCollection
    attr_reader :collection

    def initialize(collection)
      @collection = collection
    end

    def pluck(attribute)
      collection.map { |permission| permission.public_send(attribute) }
    end
  end

  private_constant :PermissionStubbedCollection
end
