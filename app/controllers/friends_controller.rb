class FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :regulate_user
  before_action :set_guide, only: [:send_request, :destroy, :accept, :reject]
  
  def index
    if params[:friends_page]
      if params[:friends_page] == 'true'
        @friends = current_user.friends_profiles.page(params[:page]).per(Settings.friend.page_count)
      else
        @not_friends = current_user.not_friends_profiles.page(params[:page]).per(Settings.friend.page_count)
      end
    else
      @friends = current_user.friends_profiles.page(params[:page]).per(Settings.friend.page_count)
      @not_friends = current_user.not_friends_profiles.page(params[:page]).per(Settings.friend.page_count)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def send_request
    message = Message.send_firends_message(@guide.id, current_user.id, nil, nil, send_request_params[:message].present? ? send_request_params[:message] : 'no_message')
    if message
      current_user.friend_request(@guide)
      FriendMailer.send_request_notification(current_user, @guide, message.message_thread_id).deliver_now!
      redirect_to message_thread_path(message.message_thread_id), notice: Settings.friend.msg.request
    else
      flash.now[:alert] = Settings.friend.save.failure
      render 'index'
    end
  end
  
  def accept
    message = Message.send_firends_message(@guide.id, current_user.id, Settings.friend.msg.accept, params[:message_thread_id])
    if message
      current_user.accept_request(@guide)
      FriendMailer.send_update_notification(current_user, @guide, message.message_thread_id, Settings.friend.status.accepted).deliver_now!
      redirect_to message_thread_path(message.message_thread_id), notice: Settings.friend.msg.accept
    else
      redirect_to message_thread_path(params[:message_thread_id]), alert: Settings.friend.save.failure
    end
  end
  
  def reject
    message = Message.send_firends_message(@guide.id, current_user.id, Settings.friend.msg.rejected, params[:message_thread_id])
    if message
      current_user.decline_request(@guide)
      FriendMailer.send_update_notification(current_user, @guide, message.message_thread_id, Settings.friend.status.rejected).deliver_now!
      redirect_to message_thread_path(message.message_thread_id), notice: Settings.friend.msg.rejected
    else
      redirect_to message_thread_path(params[:message_thread_id]), alert: Settings.friend.save.failure
    end
  end
  
  def destroy
    current_user.remove_friend(@guide)
    redirect_to friends_path
  end
  
  def search
    if params[:friends_page]
      if params[:friends_page] == 'true'
        @friends = current_user.search_friends(search_params).page(params[:page]).per(Settings.friend.page_count)
      else
        @not_friends = current_user.search_not_friends(search_params).page(params[:page]).per(Settings.friend.page_count)
      end
    else
      @friends = current_user.search_friends(search_params).page(params[:page]).per(Settings.friend.page_count)
      @not_friends = current_user.search_not_friends(search_params).page(params[:page]).per(Settings.friend.page_count)
    end
    respond_to do |format|
      format.js {}
    end
  end
  
  def search_friends
    @friends = current_user.search_friends(search_params).page(params[:page]).per(Settings.friend.page_count)
    respond_to do |format|
      format.js {}
    end
  end
  
  def friends_list
    session[:guide_ids] = nil if session[:previous_url].blank? or !session[:previous_url].include?('friends')
    @friends = current_user.friends_profiles.page(params[:page]).per(Settings.friend.page_count)
    @reservation = Reservation.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def send_message_to_selected_guides
    @reservation = Reservation.find(params[:id])
    if session[:guide_ids].blank?
      redirect_to friends_list_reservation_path(@reservation.id), alert: Settings.friend.send_message_to_selected_guides.failure
    else
      session[:guide_ids].each do |guide_id|
        message = Message.send_message_to_selected_guides(@reservation, guide_id)
        PairGuideMailer.selected_notification(current_user, User.find(guide_id), message.message_thread_id).deliver_now!
      end
      @reservation.pg_under_construction!
      session[:guide_ids] = nil
      redirect_to friends_list_reservation_path(@reservation.id), notice: Settings.friend.send_message_to_selected_guides.success
    end
  end
  
  #select guide ajax
  def set_selected_guides
    if request.xhr?
      if session[:guide_ids].blank?
        selected_guides = []
        selected_guides.push(params[:guide_id])
        session[:guide_ids] = selected_guides
        return render text: 'added'
      else
        selected_guides = session[:guide_ids]
        if selected_guides.include?(params[:guide_id])
          selected_guides.delete(params[:guide_id])
          session[:guide_ids] = selected_guides
          return render text: 'deleted'
        elsif selected_guides.count > 4
          return render text: 'count_over'
        else
          selected_guides.push(params[:guide_id])
          session[:guide_ids] = selected_guides
          return render text: 'added'
        end
      end
    end
  end
  
  private
  
  def set_guide
    @guide = User.find(params[:id])
  end
  
  def search_params
    params.require(:search).permit(:friends_or_not, :keyword)
  end
  
  def send_request_params
    params.require(:send_request).permit(:message)
  end
  
  def regulate_user
    return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if current_user.guest?
  end
end
