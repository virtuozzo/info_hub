require 'spec_helper'

describe Core::Users::SessionsController, type: :controller do
  routes { Core::Engine.routes }

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#new' do
    subject { get :new }

    context 'force saml login' do
      before { allow(OnApp.configuration).to receive(:force_saml_login_only).and_return true }

      it { is_expected.to render_template('new_saml_only') }
    end
  end
end
