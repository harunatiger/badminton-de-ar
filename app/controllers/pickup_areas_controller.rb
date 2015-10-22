class PickupAreasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing_pickup_area, only: [:update, :destroy]
  before_action :set_listing

  def manage

  end


  def create

  end

  def update_all

  end

  def update

  end

  def destroy

  end

  private
  def set_listing_pickup_area
    if params[:listing_id].nil?
      @listing_pickup_areas = ListingPickupArea.find(params[:listing_id])
    else
      @listing_pickup_areas = ListingPickupArea.find(1)
    end

  end

  def set_listing
    if params[:listing_id].nil?
      @listing = Listing.find(params[:listing_id])
    else
      @listing = Listing.find(1)
    end

  end

  def listing_pickup_area_params
    params.require(:listing).permit(:pickup_areas_ids)

  end

end