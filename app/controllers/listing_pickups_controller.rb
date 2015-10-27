class ListingPickupsController < ApplicationController
  before_action :set_listings_by_pickup_type


  def show
  end


  private

    def set_listings_by_pickup_type
      if params[:type]
        case params[:type]
          when 'area' then
            pickup_obj = PickupArea.find(params[:id])

          when 'category' then
            pickup_obj = PickupCategory.find(params[:id])

          when 'tag' then
            pickup_obj = PickupTag.find(params[:id])

          else
            return redirect_to root_path, notice: Settings.listings.error.invalid_listing_id
        end
        return redirect_to root_path, notice: Settings.listings.error.invalid_listing_id if pickup_obj.blank?

        @pickup_title = pickup_obj.name
        @pickup_cover_image = pickup_obj.cover_image

        @listings = pickup_obj.listings.opened
        return redirect_to root_path, notice: Settings.listings.error.invalid_listing_id if @listings.blank?

      else
        @listings = Listing.opened
      end
    end

end
