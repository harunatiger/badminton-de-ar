class WelcomeController < ApplicationController
  def index
    @listings = Listing.opened
    @pickup_areas =  PickupArea.find(PickupArea.pluck(:id).shuffle[0..3])
    @pickup_categories =  PickupCategory.find(PickupCategory.pluck(:id).shuffle[0..3])
    @pickup_tags =  PickupTag.find(PickupTag.pluck(:id).shuffle[0..3])
  end
end
