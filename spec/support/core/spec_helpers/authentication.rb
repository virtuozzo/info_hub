module Core
  module SpecHelpers
    module Authentication
      def mock_user(stubs={})
        @user_group ||= mock_model(User, stubs).as_null_object
      end

      def mock_onapp(stubs={})
        @user_group ||= mock_model(OnApp::Configuration, stubs).as_null_object
      end

      def assume_logged_in(user = nil)
        user = insert(:user) unless user
        allow(controller).to receive(:login_required).and_return true
        mock_current_user(user)
      end

      def mock_current_user(user)
        allow(controller).to receive(:authenticate_user!).and_return true
        allow(controller).to receive(:current_user).and_return user
      end

      def assume_admin_logged_in(user = nil)
        assume_logged_in(user)
        allow(controller.current_user).to receive(:has_permission?).and_return true
      end

      def assume_god_mode_on(user = nil)
        assume_licensing_ok
        assume_logged_in(user)
      end

      def assume_licensing_ok
        if @controller.respond_to?(:license_check)
          allow(@controller).to receive(:license_check).and_return true
        end
      end

      def basic_auth(user, password)
        ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
      end
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include Core::SpecHelpers::Authentication, type: :controller
end
