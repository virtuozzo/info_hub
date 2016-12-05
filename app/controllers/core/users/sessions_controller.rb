class Core::Users::SessionsController < Devise::SessionsController
  include *Core.constantized_extensions(:'core/users/sessions_controller')

  def new
    return super unless force_saml_login?

    render 'new_saml_only'
  end

  def create
    return super unless force_saml_login?

    redirect_to onapp.new_user_session_url, alert: t('devise.sessions.regular_login_disabled')
  end

  def destroy
    if logout_from_saml?
      settings = current_user.saml_id_provider.settings
      logout_request = OneLogin::RubySaml::Logoutrequest.new
      reset_session

      redirect_to logout_request.create(settings, RelayState: core_engine.new_user_session_url)
    else
      super
    end
  end

  private

  def logout_from_saml?
    session['saml_uid'] && current_user&.saml_id_provider&.idp_slo_target_url
  end

  def force_saml_login?
    OnApp.configuration.force_saml_login_only
  end
end
