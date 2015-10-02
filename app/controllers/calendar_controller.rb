class CalendarController < ApplicationController
  def index
    @listing = Listing.find(params[:listing_id])
    gon.listing_id = params[:listing_id]
  end
end