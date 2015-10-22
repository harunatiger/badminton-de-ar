class ListingPickupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing

  def manage

  end

  def update
    @pickup_categories = Listing.find(@listing)

    if @pickup_categories.update(pickup_category_params)
      redirect_to manage_listing_listing_pickups_path(@listing.id), notice: Settings.listing_pickups.save.success
    else
      redirect_to manage_listing_listing_pickups_path(@listing.id), notice: Settings.listing_pickups.save.failure
    end
  end


  private

  def set_listing
    if !params[:listing_id].nil?
      @listing = Listing.find(params[:listing_id])
    end

  end

  def pickup_category_params
    params.require(:listing).permit(pickup_area_ids: [],pickup_category_ids: [], pickup_tag_ids: [])

  end

end