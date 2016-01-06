class FavoriteListingsController < ApplicationController
  before_action :set_favorite_listing, only: [:destroy]

  def index
    @favorite_listings = current_user.favorite_listing.page(params[:page]).per(6)
  end

  def destroy
    @favorite_listing.destroy
    respond_to do |format|
      format.html { redirect_to favorite_listings_path }
      format.json { head :no_content }
    end
  end

  private
    def set_favorite_listing
      @favorite_listing = FavoriteListing.find(params[:id])
    end
end
