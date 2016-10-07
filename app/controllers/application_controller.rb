class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  #http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD'] unless Rails.env.development?
  before_action :set_locale, :set_locale_from_remote_addr
  before_action :log_access
  after_action  :store_location
 
  def set_locale
    I18n.locale = :en
  end
  
  def store_location
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users" &&
        request.fullpath !~ Regexp.new("users/before_omniauth") &&
        request.fullpath !~ Regexp.new("\\A/users/password.*\\z") &&
        request.fullpath !~ Regexp.new("\\A/users/confirmation.*\\z") &&
        !request.xhr? && # don't store ajax calls
        @not_update_previous_url.blank?)
      session[:previous_url] = request.fullpath
    end
  end
  
  after_action  :set_last_access_date
  def set_last_access_date
    if user_signed_in?
      if current_user.last_access_date.blank? || current_user.last_access_date < Time.zone.today
        current_user.profile.enable_strict_validation = false
        current_user.update(last_access_date: Time.zone.today)
      end
    end
  end
  
  if !Rails.env.development?
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError,   with: :render_404
  end
  
  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e
    render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
  end
  
  private

  TIMEOUT = 1.hour
  def set_locale_from_remote_addr
    return check_currency_rate if session[:currency_code].present?
    language = http_accept_language.preferred_language_from(Currency.available_locales)
    session[:currency_code] = Currency.language_to_currency_code(language)
    session[:rate] = session[:currency_code] != 'JPY' ? Currency.get_rate(session[:currency_code]) : 0
    session[:latest_rate_get_time] = Time.current
  end
    
  def check_currency_rate
    if session[:latest_rate_get_time] <= TIMEOUT.ago
      session[:rate] = session[:currency_code] != 'JPY' ? Currency.get_rate(session[:currency_code]) : 0
      session[:latest_rate_get_time] = Time.current
    end
  end

  def log_access
    if !request.fullpath.index('admin') && !request.env["HTTP_USER_AGENT"].index('ELB-HealthChecker')
      if session[:country].blank?
        remoteaddr = ''
        if request.env['HTTP_X_FORWARDED_FOR']
          remoteaddr = request.env['HTTP_X_FORWARDED_FOR'].split(",")[0]
        else		
          remoteaddr = request.env['REMOTE_ADDR'] if request.env['REMOTE_ADDR']
        end
        geoip = GeoIP.new(Rails.root + "db/GeoIP.dat").country(remoteaddr)
        session[:country] = geoip.country_code2
      end

      access_params = {
        session_id: session[:session_id],
        user_id: user_signed_in? ? current_user.id : nil,
        method: request.method,
        page: request.fullpath,
        referer: request.referer,
        country: session[:country],
        devise: request.env["HTTP_USER_AGENT"],
        accessed_at: Time.zone.now
        }
      Access.insert_record(access_params)
    end
  end
end
