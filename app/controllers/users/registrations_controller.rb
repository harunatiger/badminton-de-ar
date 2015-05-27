class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super
    profile = Profile.create(user_id: resource.id)
    ProfileImage.create(user_id: resource.id, profile_id: profile.id, image: '', caption: '')
  end

  def build_resource(hash=nil)
    hash[:uid] = User.create_unique_string
    super
  end

end
