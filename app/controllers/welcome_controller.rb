class WelcomeController < ApplicationController
  def index
    @listings = Listing.opened
    @pickup_areas =  PickupArea.find(PickupArea.where.not(selected_listing: nil).pluck(:id).shuffle[0..3])
    @pickup_categories =  PickupCategory.find(PickupCategory.where.not(selected_listing: nil).pluck(:id).shuffle[0..3])
    @pickup_tags =  PickupTag.find(PickupTag.where.not(selected_listing: nil).pluck(:id).shuffle[0..3])
  end
end
