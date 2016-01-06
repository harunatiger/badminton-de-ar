class FavoriteListingsController < ApplicationController
  before_action :set_favorite_listing, only: [:destroy]

  def index
    @favorite_listings = FavoriteListing.where(user_id: current_user.id).page(params[:page]).per(2)
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
