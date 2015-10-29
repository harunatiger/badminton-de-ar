class WelcomeController < ApplicationController
  def index
    @listings = Listing.opened
    @pickup_top = Pickup.pickup_obj_by_order_number(1)
    @pickups = Pickup.pickup_arry
  end
end
