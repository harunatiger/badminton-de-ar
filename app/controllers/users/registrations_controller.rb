class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super
    profile = Profile.create(user_id: resource.id)
    #ProfileImage.create(user_id: resource.id, profile_id: profile.id, image: '', caption: '')
  end
  
  def create_email
    auth = OmniAuth::AuthHash.new(session["omniauth.auth"])
    auth.info.email = params[:user]['email']
    @user = User.find_for_facebook_oauth(auth, current_user, true)
    if @user.persisted?
      session["omniauth.auth"] = nil
      @status = 'success'
    else
      @status = 'failure'
    end
  end
  
  def clear_auth_session
    if request.xhr?
      session["omniauth.auth"] = nil
      return render text: 'success'
    end
  end

  def build_resource(hash=nil)
    hash[:uid] = User.create_unique_string
    super
  end
  
  def destroy
    current_user.delete_children
    current_user.cancel_reservations
    current_user.update_user_for_close(params[:user][:reason])
    current_user.soft_destroy
    Users::Mailer.withdraw_notification_to_owner(current_user).deliver_now!
    sign_out current_user
    respond_to do |format|
      flash[:notice] = Settings.user.destroy.success
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end
  
  def withdraw
  end
  
  protected
  def update_resource(resource, params)
    if params[:email]
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end
end
