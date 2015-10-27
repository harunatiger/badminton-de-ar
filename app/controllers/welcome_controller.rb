class WelcomeController < ApplicationController
  def index
    @listings = Listing.opened
    @pickup_areas = PickupArea.first(4)
    @pickup_categories = PickupCategory.first(4)
    @pickup_tags = PickupTag.first(4)
  end
end
