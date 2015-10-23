class ListingPickupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing, only: [:manage, :update]
  before_action :set_listings_by_pickup_type, only: [:show]

  def manage
  end

  def show
  end

  def update
    @listing_pickups = Listing.find(@listing)

    if @listing_pickups.update(listing_pickup_params)
      redirect_to manage_listing_listing_pickups_path(@listing.id), notice: Settings.listing_pickups.save.success
    else
      redirect_to manage_listing_listing_pickups_path(@listing.id), notice: Settings.listing_pickups.save.failure
    end
  end


  private

    def set_listing
      @listing = Listing.find(params[:listing_id])
    end

    def set_listings_by_pickup_type
      if params[:type]
        case params[:type]
          when 'area' then
            pickup_fld = PickupArea.find(params[:id])
          when 'category' then
            pickup_fld = PickupCategory.find(params[:id])
          when 'tag' then
            pickup_fld = PickupTag.find(params[:id])
          else

        end

        @listings = pickup_fld.listings
        @pickup_title = pickup_fld.name
        @pickup_cover_image = pickup_fld.cover_image

      else
        @listings = []
      end
    end

    def listing_pickup_params
      params.require(:listing).permit(pickup_area_ids: [],pickup_category_ids: [], pickup_tag_ids: [])
    end

end
