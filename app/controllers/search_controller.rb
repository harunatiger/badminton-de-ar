class SearchController < CommonSearchController
  def search
    basic_search
    gon.pickup_areas = PickupArea.list_for_gon
  end
  
  def search_result
  end
  
  def get_information
    if request.xhr?
      if params[:target] == 'listings'
        listing = Listing.find_by_id(params[:id])
        return render partial: 'shared/info_window', locals: { target: listing}
      else
        spot = Spot.find_by_id(params[:id])
        return render partial: 'shared/info_window', locals: { target: spot}
      end
    end
  end
end
