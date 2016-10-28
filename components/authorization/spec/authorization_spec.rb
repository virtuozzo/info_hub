require 'spec_helper'

describe Authorization, type: :helper do
  let!(:wl_1)        { create :user_white_list, ip: '10.0.0.1' }
  let!(:wl_2)        { create :user_white_list, ip: '10.0.0.1/24' }
  let(:current_user) { double(user_white_lists: UserWhiteList.scoped) }
  let(:test_class) do
    Class.new do
      include Authorization

      def current_user; end
      def request; end

      def session
        {}
      end
    end
  end
  let(:auth) do
    auth = test_class.new

    allow(auth).to receive(:current_user).and_return current_user

    auth
  end

  before { Rails.configuration.authorization_debug = true }

  describe '#ip_white_list?' do
    context 'when user is signed in' do
      it 'returns true if user white list empty' do
        allow(auth).to receive(:request).and_return double(remote_ip: '10.0.0.1')
        allow(current_user).to receive(:user_white_lists).and_return []

        expect(auth.send(:ip_white_list?)).to be true
      end

      it 'returns true if ip matches ip in white list' do
        allow(auth).to receive(:request).and_return double(remote_ip: '10.0.0.2')

        expect(auth.send(:ip_white_list?)).to be true
      end

      it 'returns true if ip matches network in white list' do
        allow(auth).to receive(:request).and_return double(remote_ip: '10.0.0.1')
        allow(auth).to receive_message_chain(:current_user, :user_white_lists, :where, :first).and_return false

        expect(auth.send(:ip_white_list?)).to be true
      end

      it 'returns false if ip does not match ip or network in white list' do
        allow(auth).to receive(:request).and_return double(remote_ip: '10.0.1.10')
        allow(auth).to receive_message_chain(:current_user, :user_white_lists, :where, :first).and_return false

        expect(auth.send(:ip_white_list?)).to be false
      end
    end

    context 'when user is not signed in' do
      it 'returns false' do
        allow(auth).to receive(:current_user).and_return nil
        allow(auth).to receive(:request).and_return double(remote_ip: '10.0.0.1')

        expect(auth.send(:ip_white_list?)).to be false
      end
    end
  end

  describe '#authorized?' do
    subject { authorized? }

    it { is_expected.to be true }
  end

  describe '#authorized_debuger' do
    subject { authorized_debuger { puts 'Hello!' } }

    after { subject }

    it 'prints yield' do
      expect(STDOUT).to receive(:puts).with('Hello!')
    end

    context 'does not turned on in config' do
      it 'does not print yield' do
        Rails.configuration.authorization_debug = false

        expect(STDOUT).not_to receive(:puts).with('Hello!')
      end
    end
  end

  describe 'store_location' do
    let(:onapp_url) { 'https://onapp.com' }

    subject         { auth.send(:store_location) }

    it 'sets fullpath to session' do
      allow(auth).to receive(:request).and_return double(fullpath: onapp_url)

      expect(subject).to eq onapp_url
    end
  end
end

describe SpecController, type: :controller do
  describe '#redirect_back_or_default' do
    it 'redirects to default if no session specified' do
      get :test_redirect_back_or_default

      expect(response).to redirect_to '/'
    end

    it 'redirects to session based value if it is present and cleans session' do
      get :test_redirect_back_or_default, return_to: 1

      expect(response).to redirect_to redirector_path
      expect(session[:return_to]).to be_nil
    end
  end

  describe '#authorized_denied' do
    let(:singed_in?) { true }

    before { allow(controller).to receive(:user_signed_in?).and_return singed_in? }

    context 'api' do
      it 'returns status 403 during api' do
        get :denied, format: :json

        expect(response).to have_http_status :forbidden
      end
    end

    context 'html' do
      before { get :denied }

      it 'redirects to root in html' do
        expect(response).to redirect_to root_path
      end

      context 'not singed in' do
        let(:singed_in?) { false }

        it 'redirects to log in page if not authorized' do
          expect(response).to redirect_to controller.core_engine.new_user_session_path
        end
      end
    end
  end

  describe '#access_denied' do
    let(:singed_in?) { true }

    before do
      allow(controller).to receive(:user_signed_in?).and_return singed_in?
      allow(Authorization).to receive(:app_name).and_return 'Name'
    end

    context 'api' do
      it 'returns 401' do
        get :access, format: :json

        expect(response).to have_http_status :unauthorized
      end
    end

    context 'html' do
      before { get :access }

      it 'redirects to root in html' do
        expect(response).to redirect_to root_path
      end

      context 'not singed in' do
        let(:singed_in?) { false }

        it 'redirects to log in page if not authorized' do
          expect(response).to redirect_to controller.core_engine.new_user_session_path
        end
      end
    end
  end

  describe '#login_required' do
    let(:user) { create :user }

    before { sign_in user }

    context 'current_user exists and it is suspended' do
      before { controller.current_user.suspended = true }

      it 'logs him out and clears session' do
        expect(controller).to receive(:reset_session)

        get :required

        expect(response).to redirect_to controller.core_engine.new_user_session_path
      end
    end

    context 'current_user exists and it is deleted' do
      before { controller.current_user.deleted = true }

      it 'logs him out and clears session' do
        expect(controller).to receive(:reset_session)

        get :required

        expect(response).to redirect_to controller.core_engine.new_user_session_path
      end
    end

    context 'current_user exists and it is active' do
      before { controller.current_user.active = true }

      it 'does not clear session' do

        allow(controller).to receive(:render).and_return true
        expect(controller).not_to receive(:reset_session)

        get :required
      end
    end

    context 'real user id presents' do
      before { session[:real_user_id] = user.id }

      it 'signs out if ip is not in white lists' do
        allow(controller).to receive(:ip_white_list?).and_return false

        get :required

        expect(response).to redirect_to controller.core_engine.new_user_session_path
      end
    end

    context 'user not signed in' do
      it 'throws access denied' do
        allow(controller).to receive(:user_signed_in?).and_return false

        get :required, format: :json

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe '#default_authorized?' do
    let(:user)    { create :user }
    let(:action)  { :create }
    let(:aliases) { { index: :read, show: :read, new: :create,
                      create: :create, edit: :update, update: :update,
                      destroy: :delete } }

    before { sign_in user }

    context 'instace' do
      context 'has permission' do
        it 'writes logs and performs action' do
          expect(Rails.logger).to receive(:debug).with("Authorization. resource: #{user.inspect}")
          expect(Rails.logger).to receive(:debug).with("Authorization. action: #{action}")
          expect(Rails.logger).to receive(:debug).with("Authorization. mapping: #{aliases.with_indifferent_access.inspect}")
          expect(Rails.logger).to receive(:debug).with("Authorization. @resource_action: #{action}")

          get :authorized

          expect(response).to have_http_status :success
          expect(response.body).to render_template text: 'Success!'
        end
      end

      context 'has no permission' do
        let(:action) { :edit }

        it 'writes specific logs and does not perform action' do
          allow(Rails.logger).to receive(:warn).with("Was used unknown action `edit` for `users`")

          expect(Rails.logger).to receive(:debug).with("Authorization. resource: #{user.inspect}")
          expect(Rails.logger).to receive(:debug).with("Authorization. action: #{action}")
          expect(Rails.logger).to receive(:debug).with("Authorization. mapping: #{aliases.with_indifferent_access.inspect}")
          expect(Rails.logger).to receive(:debug).with("Authorization. @resource_action: #{action}")
          expect(Rails.logger).to receive(:debug).with("Authorization. User permissions: #{user.permission_identifiers.inspect}")
          expect(Rails.logger).to receive(:debug).with("Authorization. User not authorized!")
          expect(Rails.logger).to receive(:warn).with("Authorization. Required permission is \e[31musers.edit\e[0m")

          get :unauthorized

          expect(response).not_to have_http_status :success
        end
      end
    end

    context 'class' do
      context 'has permission' do
        it 'writes logs and performs action' do
          expect(Rails.logger).to receive(:debug).with("Authorization. resource: #{User.inspect}")
          expect(Rails.logger).to receive(:debug).with("Authorization. action: #{action}")
          expect(Rails.logger).to receive(:debug).with("Authorization. mapping: #{aliases.with_indifferent_access.inspect}")
          expect(Rails.logger).to receive(:debug).with("Authorization. @resource_action: #{action}")

          get :class_authorized

          expect(response).to have_http_status :success
          expect(response.body).to render_template text: 'Success!'
        end
      end
    end

    context 'has no permission' do
      let(:action) { :edit }

      it 'writes specific logs and does not perform action' do
        allow(Rails.logger).to receive(:warn).with("Was used unknown action `edit` for `users`")

        expect(Rails.logger).to receive(:debug).with("Authorization. resource: #{User.inspect}")
        expect(Rails.logger).to receive(:debug).with("Authorization. action: #{action}")
        expect(Rails.logger).to receive(:debug).with("Authorization. mapping: #{aliases.with_indifferent_access.inspect}")
        expect(Rails.logger).to receive(:debug).with("Authorization. @resource_action: #{action}")
        expect(Rails.logger).to receive(:debug).with("Authorization. User permissions: #{user.permission_identifiers.inspect}")
        expect(Rails.logger).to receive(:debug).with("Authorization. User not authorized!")
        expect(Rails.logger).to receive(:warn).with("Authorization. Required permission is \e[31musers.edit\e[0m")

        get :class_unauthorized

        expect(response).not_to have_http_status :success
      end
    end
  end
end
