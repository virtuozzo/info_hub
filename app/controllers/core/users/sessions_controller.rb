class Core::Users::SessionsController < Devise::SessionsController
  include *Core.constantized_extensions(:'core/users/sessions_controller')

  def new
    return super unless force_saml_login?

    render 'new_saml_only'
  end

  def create
    return super unless force_saml_login?

    redirect_to core_engine.new_user_session_url, alert: t('devise.sessions.regular_login_disabled')
  end

  private

  def force_saml_login?
    OnApp.configuration.force_saml_login_only
  end
end
