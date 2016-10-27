class UnscheduledToursController < ApplicationController
  before_action :store_location, only: [:for_guest, :for_guide]
  before_action :authenticate_user!
  before_action :set_unscheduled_tour, only: [:show]
  before_action :set_listing
  before_action :regulate_user

  # GET /unscheduled_tours/new
  def new
    session[:guide_ids] = nil
    @unscheduled_tour = UnscheduledTour.new
    @friends = current_user.friends_profiles.order_by_created_at_asc.page(params[:page]).per(Settings.friend.page_count)
    respond_to do |format|
      format.html
      format.js { render template: "friends/friends_list"}
    end
  end

  # POST /unscheduled_tours
  # POST /unscheduled_tours.json
  def create
    ActiveRecord::Base.transaction do
      @unscheduled_tour = UnscheduledTour.create!(listing_id: @listing.id, guide_id: @listing.user_id)
      if session[:guide_ids].present?
        session[:guide_ids].each do |guide_id|
          UnscheduledTourGuide.create!(unscheduled_tour_id: @unscheduled_tour.id, pair_guide_id: guide_id)
        end
      end
      session[:guide_ids] = nil
      redirect_to listing_unscheduled_tour_path(@listing, @unscheduled_tour)
    end
    rescue => e
    redirect_to new_listing_unscheduled_tour_path(@listing)
  end
  
  def show
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unscheduled_tour
      @unscheduled_tour = UnscheduledTour.find_by_uuid(params[:uuid])
    end
  
    def set_listing
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure unless @listing = Listing.find_by_id(params[:listing_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unscheduled_tour_params
      params.require(:unscheduled_tour).permit(:listing_id)
    end
  
    def regulate_user
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if @listing.user_id != current_user.id
    end
end
