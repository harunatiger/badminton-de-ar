class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  #http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD'] unless Rails.env.development?
  before_action :set_locale, :set_locale_from_remote_addr
 
  def set_locale
    I18n.locale = :en
  end
  
  after_action  :store_location
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
end
