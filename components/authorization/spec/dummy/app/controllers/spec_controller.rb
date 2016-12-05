class SpecController < ApplicationController
  include Authorization

  def test_redirect_back_or_default
    session[:return_to] = redirector_path if params[:return_to]

    redirect_back_or_default('/')
  end

  def redirector; end

  def denied
    authorized_denied
  end

  def access
    access_denied
  end

  def required
    login_required
  end

  def authorized
    default_authorized?(current_user, :create) ? render(text: 'Success!') : authorized_denied
  end

  def class_authorized
    default_authorized?(User, :create) ? render(text: 'Success!') : authorized_denied
  end

  def unauthorized
    default_authorized?(current_user, :edit) ? render(text: 'Success!') : authorized_denied
  end

  def class_unauthorized
    default_authorized?(User, :edit) ? render(text: 'Success!') : authorized_denied
  end

  def new_user_session; end

  def onapp
    OpenStruct.new(new_user_session_path: '/users/log_in')
  end
end
