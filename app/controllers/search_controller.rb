class SearchController < ApplicationController
  def search
    @listings = Listing.search(search_params)
    @spots = Spot.all
    @hit_count = 0
    
    if @listings.present?
      gon.listing_destinations = ListingDestination.where(listing_id: @listings.ids) if @listings.present?
      @hit_count += @listings.count 
    end
    
    if @spots.present?
      @hit_count += @spots.count
    end
    @conditions = search_params
  end
  
  def search_result
  end
  
  private
  def search_params
    params.require(:search).permit(:location, :latitude, :longitude, :schedule, :num_of_guest, :price, :confection, :tool, :wafuku, :keywords, :where)
  end
end
