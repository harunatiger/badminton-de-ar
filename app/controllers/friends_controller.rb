class FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_guide, only: [:send_request, :destroy, :accept, :reject]
  
  def index
    @friends = current_user.friends_profiles.page(params[:page]).per(12)
    @not_friends = current_user.not_friends_profiles.page(params[:page]).per(12)
  end
  
  def send_request
    message = Message.send_firends_message(@guide.id, current_user.id, Settings.friend.msg.request, nil, send_request_params[:message])
    if message
      current_user.friend_request(@guide)
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
      redirect_to message_thread_path(message.message_thread_id), notice: Settings.friend.msg.accept
    else
      redirect_to message_thread_path(params[:message_thread_id]), alert: Settings.friend.save.failure
    end
  end
  
  def reject
    message = Message.send_firends_message(@guide.id, current_user.id, Settings.friend.msg.rejected, params[:message_thread_id])
    if message
      current_user.decline_request(@guide)
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
    @friends = current_user.search_friends(search_params).page(params[:page]).per(12)
    @not_friends = current_user.search_not_friends(search_params).page(params[:page]).per(12)
    respond_to do |format|
      format.js {}
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
end
