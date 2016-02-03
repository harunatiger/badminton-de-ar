class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  #http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD'] unless Rails.env.development?
  
  after_action  :store_location
  def store_location
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users" &&
        request.fullpath !~ Regexp.new("\\A/users/password.*\\z") &&
        request.fullpath !~ Regexp.new("\\A/users/confirmation.*\\z") &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    #before_url = request.referrer
    respond_to do |format|
      format.html { redirect_to root_path, alert: Settings.regulate_user.user_id.failure }
      format.json { head :no_content  }
    end
  end
end
