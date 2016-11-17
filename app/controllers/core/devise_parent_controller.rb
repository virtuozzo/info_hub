class Core::DeviseParentController < ActionController::Base
  include *Core.constantized_extensions(:'core/devise_parent_controller')

  protect_from_forgery except: :create

  layout 'sessions'

  private

  def after_sign_out_path_for(resource)
    core_engine.new_user_session_path
  end

  def after_sign_in_path_for(resource)
    if !(resource.need_change_password? || resource.need_enter_yubikey?)
      change_default_email_notification_settings(resource)
    end
    session[:stop_showing_whitelist] = Time.now + 20.seconds
    session[:user_return_to] || super
  end

  def change_default_email_notification_settings(user)
    if user.has_permission?(:settings) && email_cloud_settings_default? && current_user
      flash[:error] = I18n.t('dashboard.warning.default_cloud_settings')
    end
  end

  def email_cloud_settings_default?
    # TODO OK@INFRA 5.3 CORE-8204
    if system_notification?
      { system_email:         'app@onapp.com',
        system_support_email: 'support@onapp.com',
        system_host:          'onapp.com'
      }.any? { |opt, val| OnApp.configuration.public_send(opt) == val }
    end
  end

  def system_notification?
    OnApp.configuration.enable_notifications
  end
end
