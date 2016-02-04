class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super
    profile = Profile.create(user_id: resource.id)
    #ProfileImage.create(user_id: resource.id, profile_id: profile.id, image: '', caption: '')
  end

  def build_resource(hash=nil)
    hash[:uid] = User.create_unique_string
    super
  end
  
  def destroy
    current_user.delete_children
    p params[:user][:reason]
    current_user.update_user_for_close(params[:user][:reason])
    current_user.soft_destroy
    sign_out current_user
    respond_to do |format|
      format.html { redirect_to root_path, notice: Settings.user.destroy.success }
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
