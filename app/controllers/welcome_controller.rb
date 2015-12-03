class WelcomeController < ApplicationController
  def index
    @profiles = Profile.guides.includes(:profile_image).order("RANDOM()")
    @pickups = Pickup.find(Pickup.where.not(selected_listing: nil).pluck(:id))
  end
end
