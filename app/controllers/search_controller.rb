class SearchController < ApplicationController
  def search
    @hit_count = 0
    @results = []
    @new_listings = []
    gon.locations = []
    if search_params['sort_by'].blank? || search_params['sort_by'] == 'Tour'
      listings = Listing.search(search_params)
      @new_listings = listings.created_new.order_by_created_at_desc.limit(4)
      gon.locations += ListingDestination.where(listing_id: listings.ids) if listings.present?
      @results += listings if listings.present?
      @hit_count += listings.count if listings.present?
    end
    
    if search_params['sort_by'].blank? || search_params['sort_by'] == 'Spot'
      spots = Spot.search(search_params)
      gon.locations += spots if spots.present?
      @results += spots if spots.present?
      @hit_count += spots.count if spots.present?
    end
    
    @conditions = search_params
  end
  
  def search_result
  end
  
  private
  def search_params
    params.require(:search).permit(:location, :latitude, :longitude, :sort_by, :spot_category, :category1, :category2, :category3, :schedule, :num_of_people, :duration_range, language_ids: [])
  end
end
