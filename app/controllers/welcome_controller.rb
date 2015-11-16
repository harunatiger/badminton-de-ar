class WelcomeController < ApplicationController
  def index
    @profiles = Profile.guides.includes(:profile_image)
    @pickups = Pickup.find(Pickup.where.not(selected_listing: nil))
  end
end
