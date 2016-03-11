class FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_guide, only: [:send_request, :destroy]
  
  def index
    @friends = current_user.friends_profiles.page(params[:page]).per(12)
    @not_friends = current_user.not_friends_profiles.page(params[:page]).per(12)
  end
  
  def send_request
    current_user.friend_request(@guide)
    @guide.accept_request(current_user)
    redirect_to friends_path
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
end
