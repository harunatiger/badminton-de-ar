class CalendarController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing, only: [:index]
  before_action :regulate_user, only: [:index]
  def index
    gon.listing_id = params[:listing_id]
  end

  def common_ngdays
    gon.user_id = current_user.id
  end

  private

    def set_listing
      @listing = Listing.find(params[:listing_id])
    end

    def regulate_user
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if @listing.user_id != current_user.id
    end
end
