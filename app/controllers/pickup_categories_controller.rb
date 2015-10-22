class PickupCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing_pickup_category, only: [:update, :destroy]
  before_action :set_listing

  def manage

  end


  def create
    @listing_pickup_categories = ListingPickupCategory.create({listing_id: @listing_pickup_category.id, pickup_category_id:1})

  end

  def update_all
    @listing_pickup_categories = ListingPickupCategory.new(listing_pickup_category_params, 1)
    @otaru = PickupCategory.find(4)
    @listing.pickup_categories << @otaru
  end

  def update

  end

  def destroy
    @listing_pickup_categories.destroy

  end

  private
    def set_listing_pickup_category
      if params[:listing_id].nil?
        @listing_pickup_categories = ListingPickupCategory.find(params[:listing_id])
      else
        @listing_pickup_categories = ListingPickupCategory.find(1)
      end

    end

    def set_listing
      if params[:listing_id].nil?
        @listing = Listing.find(params[:listing_id])
      else
        @listing = Listing.find(1)
      end

    end

    def listing_pickup_category_params
      params.require(:listing).permit(:pickup_category_ids)

    end

end