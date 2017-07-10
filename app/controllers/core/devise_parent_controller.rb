class Core::DeviseParentController < ActionController::Base
  include *Core.constantized_extensions(:'core/devise_parent_controller')

  protect_from_forgery except: :create

  layout 'sessions'

  private

  def after_sign_out_path_for(resource)
    core_engine.new_user_session_path
  end

  def after_sign_in_path_for(resource)
    session[:stop_showing_whitelist] = Time.now + 20.seconds
    session[:user_return_to] || super
  end
end
