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
  
  protected
  def update_resource(resource, params)
    if params[:email]
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end
end
