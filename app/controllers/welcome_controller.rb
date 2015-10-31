class WelcomeController < ApplicationController
  def index
    @profiles = Profile.guides.includes(:profile_image)
    @pickup_top = Pickup.pickup_obj_by_order_number(1)
    @pickups = Pickup.pickup_arry
  end
end
