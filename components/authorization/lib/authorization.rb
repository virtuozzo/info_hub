require 'ipaddr'
require 'devise'
require 'rails'

require_relative '../../permissions/lib/permissions'

module Authorization
  include ActionController::UrlFor
  include ActionController::RackDelegation

  mattr_accessor :app_name, :new_user_session_path

  protected

  # Check if the user is authorized
  def authorized?(resource = nil, action = nil, options = {})
    true
  end

  def ip_white_list?
    return false unless current_user

    lists = current_user.user_white_lists

    return true if lists.empty?
    return true if lists.where(ip: request.remote_ip).first
    return true if lists.any? { |user_white_list| request.remote_ip.in?(IPAddr.new(user_white_list.ip)) }

    false
  end

  def authorized_debuger
    yield if Rails.configuration.respond_to?(:authorization_debug) && Rails.configuration.authorization_debug
  end

  # Authorization for usual RESTful controller
  # +resource+ can be a class or an instance
  # +mapping+ maps controller actions to resource ones
  def default_authorized?(resource, action = nil, options = {},
                          custom_aliases = {}, default_action = '-not-allowed-')
    authorized_debuger do
      logger.debug("Authorization. resource: #{resource.inspect}")
      logger.debug("Authorization. action: #{action}")
    end

    default_aliases = { index: :read, show: :read, new: :create,
                        create: :create, edit: :update, update: :update,
                        destroy: :delete }
    all_aliases = default_aliases.merge(custom_aliases).with_indifferent_access

    @resource_action = (action || all_aliases.fetch(action_name, default_action)).to_s

    authorized_debuger do
      logger.debug("Authorization. mapping: #{all_aliases.inspect}")
      logger.debug("Authorization. @resource_action: #{@resource_action}")
    end

    if resource.is_a? Class
      return true if resource.authorized_for?(current_user, @resource_action, options)
    else
      return true if resource.authorized_for?(current_user, @resource_action)
    end

    authorized_debuger do
      logger.debug("Authorization. User permissions: #{current_user.permission_identifiers.inspect}")
      logger.debug("Authorization. User not authorized!")
    end

    klass = resource.is_a?(Class) ? resource : resource.class
    action = klass.name.underscore.tableize.gsub(/^.+\//, '') << ".#{@resource_action}"
    action << '.own' if options[:scope] && options[:scope].to_sym == :own
    logger.warn("Authorization. Required permission is \033[31m#{action}\033[0m")
    false
  end

  # Filter method to enforce a login requirement.
  def login_required
    if current_user && session[:real_user_id].nil?
      if current_user.suspended? || current_user.deleted?
        msg = current_user.suspended? ? 'access_denied_suspended' : 'access_denied_deleted'
        reset_session
        sign_out current_user
        return access_denied(true, I18n.t(msg, scope: :system))
      end

      reset_session unless current_user.active?
    end

    return access_denied unless user_signed_in?

    if ip_white_list?
      authorized_denied unless authorized?
    else
      reset_session
      sign_out current_user
      access_denied(true, I18n.t('system.access_denied_white_list'))
    end
  end

  # Redirect as appropriate when an access request fails.
  #
  # The default action is to redirect to the login screen.
  #
  # Override this method in your controllers if you want to have special
  # behavior in case the user is not authorized
  # to access the requested action.  For example, a popup window might
  # simply close itself.
  # status 401
  def access_denied(show_error = false, message = I18n.t('system.access_denied'))
    respond_to do |format|
      format.html do
        store_location
        flash[:error] = message if user_signed_in? || show_error
        if request.xhr?
          head :unauthorized
        else
          redirect_to user_signed_in? ? root_path : new_user_session_path
        end
      end
      format.any(:json, :xml) do
        request_http_basic_authentication I18n.t('system.api_auth', app_name: app_name)
      end
    end

    return false
  end

  # status 403
  def authorized_denied
    msg = I18n.t(:error403, scope: 'system')
    respond_to do |format|
      format.html do
        store_location

        if request.xhr?
          format.json { render text: { 'error' => msg }.to_json, status: :forbidden }
        else
          flash[:error] = msg if user_signed_in?
          redirect_to user_signed_in? ? root_path : new_user_session_path
        end
      end

      format.xml { render text: { 'error' => msg }.to_xml(root: 'errors'), status: :forbidden }
      format.json { render text: { 'error' => msg }.to_json, status: :forbidden }
    end

    return false
  end

  # Store the URI of the current request in the session.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = request.fullpath
  end

  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.  Set an appropriately modified
  #   after_filter :store_location, :only => [:index, :new, :show, :edit]
  # for any controller you want to be bounce-backable.
  def redirect_back_or_default(default, options = {})
    redirect_to((session[:return_to] || default), options)
    session[:return_to] = nil
  end

  # Inclusion hook to make #current_user and #logged_in? available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :authorized? if base.respond_to? :helper_method
  end
end
