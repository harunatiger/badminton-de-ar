class CalendarController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing, only: [:index]
  before_action :set_listings, only: [:index, :common_ngdays]
  before_action :regulate_user, only: [:index]
  def index
  end

  def common_ngdays
    return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if !current_user.main_guide?
  end

  private

    def set_listing
      @listing = Listing.find(params[:listing_id])
    end

    def set_listings
      @listings = User.find(current_user.id).listings.without_soft_destroyed
    end

    def regulate_user
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if @listing.user_id != current_user.id or !current_user.main_guide?
    end
end
