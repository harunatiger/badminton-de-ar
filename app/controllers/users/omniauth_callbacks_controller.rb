class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      if @user.unconfirmed?
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

      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end
 
end
