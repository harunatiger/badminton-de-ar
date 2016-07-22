class ProfileVideosController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_profile
  before_action :set_profile_video, only: [:destroy]
  before_action :regulate_user
  
  def upload_video
    if @profile.profile_video
      @profile_video = @profile.profile_video
      @profile_video.video = params[:profile][:profile_video_attributes][:video]
    else
      @profile_video = ProfileVideo.new(user_id: current_user.id, profile_id: @profile.id, video: params[:profile][:profile_video_attributes][:video])
    end
    
    if @profile_video.save
      @status = 'success'
    else
      @status = 'failure'
    end
  end
  
  def destroy
    @profile_video.remove_video!
    @profile_video.destroy
    respond_to do |format|
      format.html { redirect_to self_introduction_profile_path(@profile), notice: Settings.profile_video.delete.success }
    end
  end
  
  private
  def set_profile
    @profile = current_user.profile
  end
  
  def set_profile_video
    @profile_video = ProfileVideo.find(params[:id])
  end
  
  def regulate_user
    return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if @profile.user_id != current_user.id
  end
end