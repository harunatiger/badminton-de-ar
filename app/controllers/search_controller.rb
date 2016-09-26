class SearchController < ApplicationController
  def search
    @listings = Listing.all.opened.page(params[:page])
    @spots = Spot.all
    gon.listings = @listings
    
    @hit_count = @listings.count + @spots.count
    @conditions = search_params
  end
  
  def search_result
  end
  
  private
  def search_params
    params.require(:search).permit(:location, :schedule, :num_of_guest, :price, :confection, :tool, :wafuku, :keywords, :where)
  end
end
