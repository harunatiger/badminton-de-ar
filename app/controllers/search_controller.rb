class SearchController < ApplicationController
  def search
    @hit_count = 0
    @results = []
    @new_listings = []
    gon.locations = []
    session[:dummy_count] = nil if params[:page].blank?
    
    # search listings
    if search_params['sort_by'].blank? || search_params['sort_by'] == 'Tour'
      listings = Listing.search(search_params)
      if params[:page].blank?
        @new_listings = listings.created_new.order_by_created_at_desc.limit(4) if listings.present?
      end
      gon.locations += ListingDestination.where(listing_id: listings.ids) if listings.present?
      @results += listings if listings.present?
      @hit_count += listings.count if listings.present?
    end
    
    # search spots
    if search_params['sort_by'].blank? || search_params['sort_by'] == 'Spot'
      spots = Spot.search(search_params)
      gon.locations += spots if spots.present?
      if @results.present?
        @results = @results.zip(spots).flatten.compact if spots.present?
      else
        @results += spots if spots.present?
      end
      @hit_count += spots.length if spots.present?
    end
    
    # set new tours and dummy for pagenation
    if @new_listings.length > 0 && @results.length > Settings.search.display_count
      session[:dummy_count] = @new_listings.length
      session[:dummy_count] += 1 if !@new_listings.length.even?
    elsif @results.length <= Settings.search.display_count
      @new_listings = nil
    end
    
    if session[:dummy_count].present?
      dummy_start = Settings.search.display_count - session[:dummy_count]
      session[:dummy_count].times do |i|
        dummy_start + i
        @results.insert(dummy_start + i, 'dummy')
      end
    end
    
    @results = Kaminari.paginate_array(@results).page(params[:page]).per(Settings.search.display_count)
    @conditions = search_params
  end
  
  def search_result
  end
  
  private
  def search_params
    params.require(:search).permit(:location, :latitude, :longitude, :sort_by, :spot_category, :category1, :category2, :category3, :schedule, :num_of_people, :duration_range, language_ids: [])
  end
end
