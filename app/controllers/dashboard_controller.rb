class DashboardController < ApplicationController
  before_action :store_location, only: [:host_reservation_manager, :guest_reservation_manager]
  before_action :authenticate_user!
  before_action :regulate_user, only: [:index]
  before_action :set_message_new_instance

  def index
    current_user.mark_all_bookmarks_as_read
    @bookmarked_histories = current_user.bookmarked_histories
    @listings = current_user.active_listings
    @chart_data = ChartData.new(day: Time.zone.today, tour: Settings.chart_data.tours.all, data: Settings.chart_data.data.pv)
    @chart_data.set_chart_data(@listings)
  end

  def host_reservation_manager
    @reservations = Reservation.as_host_and_pair_guide(current_user).for_dashboard.order_by_created_at_desc
    @reservations.each do |reservation|		
      message = Message.where(reservation_id: reservation.id).first		
      reservation.message_thread_id = message.message_thread_id if message.present?
    end
  end

  def guest_reservation_manager
    @reservations = Reservation.as_guest(current_user).for_dashboard.includes(:campaign, :payment).order_by_created_at_desc
    @reservations.each do |reservation|		
      message = Message.where(reservation_id: reservation.id).first		
      reservation.message_thread_id = message.message_thread_id if message.present?
    end
  end
  
  def favorite_histories
    if request.xhr?
      if params[:user_id].present?
        target = 'あなた'
        histories = FavoriteUser.where(to_user_id: params[:user_id]).without_soft_destroyed.order_by_updated_at_desc
      else
        listing = Listing.find(params[:listing_id])
        target = listing.title
        histories = FavoriteListing.where(listing_id: listing.id).without_soft_destroyed.order_by_updated_at_desc
      end
      render partial: 'favorite_histories', locals: { target: target, histories: histories}
    end
  end
  
  def read_more_favorites
    if request.xhr?
      @count = params[:current_count].to_i + Settings.dashboard.favorite_display_count
      @bookmarked_histories = current_user.bookmarked_histories
    end
  end
  
  def get_chart_data
    if request.xhr?
      @chart_data = ChartData.new(chart_data_params)
      
      @chart_data.day = Date.parse(@chart_data.day)
      if params[:prev_month].present?
        @chart_data.day = @chart_data.day.prev_month
      elsif params[:next_month].present?
        @chart_data.day = @chart_data.day.next_month
      elsif params[:change_tour].present?
        @chart_data.benchmark = nil
      end
      
      @chart_data.tour = @chart_data.tour.to_i if @chart_data.tour != Settings.chart_data.tours.all
      @user = User.find(params[:user_id])
      @listings = @user.active_listings
      @chart_data.set_chart_data(@listings)
    end
  end

  private

  def set_message_new_instance
    @message = Message.new
  end
  
  def regulate_user
    return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if !current_user.main_guide?
  end
  
  def chart_data_params
    params.require(:chart_data).permit(:day, :tour, :data, :benchmark)
  end
end
