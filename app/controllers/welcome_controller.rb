class WelcomeController < ApplicationController
  def index
    @listings = Listing.opened
    @pickup_areas = PickupArea.first(1)
    @pickup_categories = PickupCategory.first(1)
    @pickup_tags = PickupTag.first(2)
  end
end
