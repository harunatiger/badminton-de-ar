class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :regulate_user, only: [:index]
  before_action :set_message_new_instance

  def index
    current_user.mark_all_bookmarks_as_read
    @bookmarked_histories = current_user.bookmarked_histories
    @listings = current_user.listings.without_soft_destroyed.order_by_updated_at_desc
  end

  def host_reservation_manager
    @reservations = Reservation.as_host_and_pair_guide(current_user).for_dashboard.order_by_created_at_desc
    @reservations.each do |reservation|		
      message = Message.where(reservation_id: reservation.id).first		
      reservation.message_thread_id = message.message_thread_id if message.present?
    end
  end

  def guest_reservation_manager
    @reservations = Reservation.as_guest(current_user).for_dashboard.includes(:campaign).order_by_created_at_desc
    @reservations.each do |reservation|		
      message = Message.where(reservation_id: reservation.id).first		
      reservation.message_thread_id = message.message_thread_id if message.present?
    end
  end
  
  def favorite_histories
    if request.xhr?
      if params[:user_id].present?
        target = 'あなた'
        histories = FavoriteUser.where(to_user_id: params[:user_id]).order_by_created_at_desc
      else
        listing = Listing.find(params[:listing_id])
        target = listing.title
        histories = FavoriteListing.where(listing_id: listing.id).order_by_created_at_desc
      end
      render partial: 'favorite_histories', locals: { target: target, histories: histories}
    end
  end

  private

  def set_message_new_instance
    @message = Message.new
  end
  
  def regulate_user
    return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if !current_user.main_guide?
  end
end
