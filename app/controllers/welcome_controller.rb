class WelcomeController < ApplicationController
  def index
    @profiles = Profile.guides.order("RANDOM()")
    @pickups = Pickup.find(Pickup.where.not(selected_listing: nil).pluck(:id))
    @announcement = Announcement.display_at('top').first
    @features = Feature.all.order_by_order_number_asc
    gon.pickup_areas = PickupArea.list_for_gon
  end
end
