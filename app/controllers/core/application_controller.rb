require 'core/onapp/responder'

class Core::ApplicationController < ActionController::Base
  include Authorization

  layout 'core/application'

  protect_from_forgery

  before_filter :authenticate_user!

  helper_method :set_breadcrumbs

  def self.responder
    OnApp::Responder
  end

  alias_method :default_redirect_to, :redirect_to

  def redirect_to(*args)
    # if we redirect, we need to keep flash messages for the next action
    flash.keep
    default_redirect_to(*args)
  end

  # CORE-2360 wrap full authentication process into database transaction in order to avoid race condition
  def authenticate_user!
    ActiveRecord::Base.transaction { super }
  end

  # short form flash_message(:notice)
  # long form for flash.now
  # flash_message(:error2, {:msg => 'bbb'}, :now)
  # flash_message(:error_occurred, :type => :error) gets message from :controller.:action.flash.error_occurred and displays as :error
  def flash_message(key, args = {}, flash_type = :now)
    controller  = args.delete(:controller) || params[:controller]
    action      = args.delete(:action)     || params[:action]
    flash_style = args.delete(:type)       || key.to_s.gsub(/\d/, '').to_sym
    msg = I18n.t(key, args.merge(scope: [controller, action, 'flash']))
    flash_type.eql?(:now) ? flash.now[flash_style] = msg : flash[flash_style] = msg
  end

  def with_flash_message(object, &block)
    if block.call(object)
      flash_message(:notice)
    else
      flash_message(:error, msg: object.errors.full_messages.to_sentence)
    end
  end

  private

  def breadcrumbs_nested?
    true
  end

  def set_breadcrumbs
    Breadcrumbs::CRUDCreator.prepare_params(self, @virtual_machine, breadcrumbs_nested: breadcrumbs_nested?)
  end

  def use_local_time
    @use_local_time ||= params[:use_local_time] || (params[:period] && params[:period][:use_local_time])
  end

  def find_period(from_offset = 48.hours)
    Time.zone = Time.find_zone(:utc) unless use_local_time
    from = params[:from] || (params[:period] && params[:period][:startdate])
    till = params[:till] || (params[:period] && params[:period][:enddate])

    from = nil if from.blank?
    till = nil if till.blank?

    if use_local_time
      begin
        @from = Time.zone.parse(from)
      rescue
        @from = from_offset.is_a?(String) || from_offset.is_a?(Symbol) ? Time.current.send(from_offset) : Time.current - from_offset
      end
      @till = Time.zone.parse(till) rescue Time.current
    else
      begin
        @from = DateTime.parse(from).utc
      rescue
        @from = from_offset.is_a?(String) || from_offset.is_a?(Symbol) ? DateTime.now.utc.send(from_offset) : DateTime.now.utc - from_offset
      end
      @till = DateTime.parse(till).utc rescue DateTime.now.utc
    end

    raise OnApp::WrongTimeRange if @till < @from

    @till = 3.month.since(@from) if @till - @from > 3.month
  end
end

# Have to put it there because I'm getting an unexpected errors in controller tests if I put it inside
# a class definition
Core::ApplicationController.include *Core.constantized_extensions(:'core/application_controller')
