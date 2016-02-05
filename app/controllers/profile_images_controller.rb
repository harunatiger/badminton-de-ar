class ProfileImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile_image, only: [:show, :edit, :update, :destroy]
  before_action :set_profile
  before_action :regulate_user, except: [:index, :create, :show]

  # GET /profile_images
  # GET /profile_images.json
  def index
    @profile_images = ProfileImage.all
  end

  # GET /profile_images/1
  # GET /profile_images/1.json
  def show
  end

  # GET /profile_images/new
  def new
    @profile_image = ProfileImage.new
  end

  # GET /profile_images/1/edit
  def edit
  end
  
  def manage
    @cover_image = @profile.cover.present? ? @profile.cover : ProfileImage.new
  end

  # POST /profile_images
  # POST /profile_images.json
  def create
    @profile_image = ProfileImage.new(profile_image_params)
    count = @profile.thumb_images.size
    @profile_image.order_num = count + 1
    respond_to do |format|
      if @profile_image.save
        format.html { redirect_to edit_profile_profile_image_path(@profile, @profile_image), notice: Settings.profile_images.save.success }
        format.json { render :show, status: :created, location: @profile_image }
        format.js { @status = 'success' }
      else
        format.html { render :new }
        format.json { render json: @profile_image.errors, status: :unprocessable_entity }
        format.js { @status = 'failure' }
      end
    end
  end

  # PATCH/PUT /profile_images/1
  # PATCH/PUT /profile_images/1.json
  def update
    respond_to do |format|
      if @profile_image.update(profile_image_params)
        format.html { redirect_to edit_profile_profile_image_path(@profile, @profile_image), notice: Settings.profile_images.save.success }
        format.json { render :show, status: :ok, location: @profile_image }
        format.js { @status = 'success' }
      else
        format.html { render :edit }
        format.json { render json: @profile_image.errors, status: :unprocessable_entity }
        format.js { @status = 'failure' }
      end
    end
  end

  # DELETE /profile_images/1
  # DELETE /profile_images/1.json
  def destroy
    @profile_image.remove_image!
    if @profile_image.cover_flg
      @profile_image.destroy
    else
      @profile_image.destroy
      @profile.thumb_images.each_with_index do |thumb_image, i|
        thumb_image.update(order_num: i + 1)
      end
    end
    respond_to do |format|
      format.html { redirect_to manage_profile_profile_images_path(@profile), notice: Settings.listing_images.delete.success }
      format.json { head :no_content }
    end
  end
  
  def change_order
    if request.xhr?
      profile = Profile.find(params[:profile_id])
      image_from = profile.thumb_images.where(order_num: params[:image_from]).first
      image_to = profile.thumb_images.where(order_num: params[:image_to]).first
      image_from.update(order_num: params[:image_to])
      image_to.update(order_num: params[:image_from])
      @profile = profile
      render partial: 'images_list', locals: { profile: @profile}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_image
      @profile_image = ProfileImage.find(params[:id])
    end

    def set_profile
      @profile = Profile.find(params[:profile_id])
    end
  
    def regulate_user
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if @profile.user_id != current_user.id
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_image_params
      params.require(:profile_image).permit(:user_id, :profile_id, :image, :cover_flg, :order_num)
    end
end
