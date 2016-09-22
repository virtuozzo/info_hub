def mock_user(stubs={})
  @user_group ||= mock_model(User, stubs).as_null_object
end

def mock_onapp(stubs={})
  @user_group ||= mock_model(OnApp::Configuration, stubs).as_null_object
end

def assume_logged_in(user = nil)
  user = insert(:user) unless user
  sign_in(user)
end

def assume_admin_logged_in(user = nil)
  assume_logged_in(user)
  allow(controller.current_user).to receive(:has_permission?).and_return(true)
end

def assume_god_mode_on(user = nil)
  assume_logged_in(user)
end

def assume_god_mode_on!(user = nil)
  assume_licensing_ok
  assume_admin_logged_in(user)
end

def basic_auth(user, password)
  ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
end
