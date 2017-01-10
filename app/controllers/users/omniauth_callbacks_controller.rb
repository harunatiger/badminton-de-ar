class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      if @user.unconfirmed?
        session[:reservation_params] = nil
        flash[:notice] = I18n.t('devise.registrations.update_needs_confirmation')
        return redirect_to root_path
      end
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      sign_in_and_redirect @user, :event => :authentication
    else
      if request.env["omniauth.auth"].info.email.blank?
        session["omniauth.auth"] = request.env["omniauth.auth"]
        return redirect_to new_user_registration_url
      end
      session[:reservation_params] = nil
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  def after_sign_in_path_for(resource)
    if session[:favorite].present?
      favorite_params = session[:favorite]
      favorite_params[:user_id] = resource.id
      Favorite.create_or_restore_from_params(session[:favorite], resource)
      session[:favorite] = nil
      session[:previous_url] || root_path
    elsif session[:reservation_params].present?
      session[:reservation_params_after_sign_up] = session[:reservation_params]
      session[:reservation_params] = nil
      listing = Listing.find_by_id(session[:reservation_params_after_sign_up]['listing_id'])
      message_thread_id = GuestThread.get_message_thread_id(listing.try('user_id'), current_user.id)
      message_thread_id ? message_thread_path(message_thread_id) : root_path
    elsif session[:to_user_id]
      if session[:to_user_id].to_i == resource.id
        message_thread_id = nil
      elsif session[:previous_url].index('profiles') && !resource.guest?
        session[:what_talk_about] = true unless current_user.main_guide?
        message_thread_id = DefaultThread.get_message_thread_id(session[:to_user_id], current_user.id)
      else
        session[:what_talk_about] = true
        message_thread_id = GuestThread.get_message_thread_id(session[:to_user_id], current_user.id)
      end
      session[:to_user_id] = nil
      message_thread_id ? message_thread_path(message_thread_id) : root_path
    else
      session[:previous_url] || root_path
    end
  end
end
