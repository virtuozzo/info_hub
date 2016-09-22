require 'active_support'

module Permissions
  require_relative 'permissions/authorizer'
  require_relative 'permissions/factory'
  require_relative 'permissions/base_model_methods'
  require_relative 'permissions/user_model_methods'

  extend self

  # allow_authorization_of FirstClass, SecondClass, if: proc { |action| action == :reboot_all }
  def allow_authorization_of(*args)
    condition = args.extract_options!.fetch(:if)

    args.each { |klass| allow_authorization_rules[klass] = condition }
  end

  def user_class_name
    raise ArgumentError.new('User class has not been set') unless @user_class_name

    @user_class_name
  end

  def user_class_name=(user_class_name)
    @user_class_name = user_class_name
  end

  def allow_authorization_rules
    @allow_authorization_rules ||= {}
  end

  def look_for_user_in(*relation_names)
    user_relations.push(*relation_names).freeze
  end

  def look_for_users_in(*relation_names)
    user_collection_relations.push(*relation_names).freeze
  end

  def user_relations
    @user_relations ||= []
  end

  def user_collection_relations
    @user_collection_relations ||= []
  end
end
