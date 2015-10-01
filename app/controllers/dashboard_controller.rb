class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message_new_instance

  def index
    @unread_messages = MessageThread.unread_messages(current_user.id)
    @never_replied_reservations = Reservation.new_requests(current_user.id).order_by_created_at_desc
    pp @never_replied_reservations
  end

  def host_reservation_manager
    @reservations = Reservation.as_host(current_user).accepts.order_by_created_at_desc
  end

  def guest_reservation_manager
    @reservations = Reservation.as_guest(current_user).order_by_created_at_desc
  end

  private

  def set_message_new_instance
    @message = Message.new
  end
end
