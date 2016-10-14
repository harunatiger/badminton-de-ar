class SearchController < ApplicationController
  def search
    session[:dummy_count] = nil if params[:page].blank?
    
    search_result = Search.search_listings_and_spots(search_params)
    @new_listings = []
    
    max_distance = Settings.search.distance
    while search_result[:results].blank? or search_result[:results].length < Settings.search.distance
      max_distance += Settings.search.distance
      search_result = Search.search_listings_and_spots(search_params, max_distance)
      break if max_distance == Settings.search.distance * 10
    end
    
    if search_result[:results].present?
      @results = search_result[:results]
      gon.locations = search_result[:gon_locations]
      
      if search_result[:listings].present?
        @new_listings = search_result[:listings].created_new.order_by_created_at_desc.limit(4)
      end
    else
      @results = []
      gon.locations = []
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
