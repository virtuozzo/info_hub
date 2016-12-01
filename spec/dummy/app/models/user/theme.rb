class User
  # TODO move user_group to onapp-core or find better decision
  def theme
    @theme ||= Theme.active.by_user_group(user_group_id).first
  end
end
