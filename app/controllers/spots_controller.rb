class SpotsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_spot, only: [:show, :edit, :update, :destroy]
  before_action :regulate_user, only: [:new, :edit, :update, :destroy]
  before_action :deleted_or_open_check, only: [:show, :edit, :update, :destroy]
  before_action :set_pickup_area, only: [:new, :edit, :create, :update]
  
  # GET /spots
  # GET /spots.json
  def index
    @spots = current_user.spots.without_soft_destroyed.includes(:spot_image).order_by_updated_at_desc
  end

  # GET /spots/1
  # GET /spots/1.json
  def show
    guide = User.find(@spot.user_id)
    @spots = guide.spots.where.not(id: @spot.id)
    @listings = guide.listings.opened.without_soft_destroyed.includes(:listing_detail).order_by_updated_at_desc.limit(3)
    @near_spots = @spot.near_spots
    if current_user
      if id = GuestThread.exists_thread?(guide.id, current_user.id)
        @message_thread = GuestThread.find(id)
      end
    end
    gon.spot = @spot
  end

  # GET /spots/new
  def new
    @spot = Spot.new
    @spot.spot_image = SpotImage.new
  end

  # GET /spots/1/edit
  def edit
  end

  # POST /spots
  # POST /spots.json
  def create
    @spot = Spot.new(spot_params)
    @spot.user_id = current_user.id
    
    respond_to do |format|
      if @spot.save
        format.html { redirect_to spots_path, notice: 'Spot was successfully created.' }
        format.json { render :show, status: :created, location: @spot }
      else
        format.html { render :new }
        format.json { render json: @spot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spots/1
  # PATCH/PUT /spots/1.json
  def update
    respond_to do |format|
      if @spot.update(spot_params)
        format.html { redirect_to spots_path, notice: 'Spot was successfully updated.' }
        format.json { render :show, status: :ok, location: @spot }
      else
        format.html { render :edit }
        format.json { render json: @spot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spots/1
  # DELETE /spots/1.json
  def destroy
    @spot.spot_image.remove_image! if @spot.spot_image.present?
    @spot.spot_image.destroy if @spot.spot_image.present?
    @spot.soft_destroy!
    respond_to do |format|
      format.html { redirect_to spots_url, notice: 'Spot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spot
      @spot = Spot.find(params[:id])
    end
  
    def regulate_user
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if !current_user.main_guide?
      if action_name != 'new'
        return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if @spot.user_id != current_user.id
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spot_params
      params.require(:spot).permit(:title, :one_word, :pickup_id, :location, :longitude, :latitude, spot_image_attributes: [ :id, :image, :image_cache ], pickup_ids: [])
    end
  
    def deleted_or_open_check
      return redirect_to session[:previous_url].present? ? session[:previous_url] : root_path, alert: Settings.spot.error.deleted if @spot.soft_destroyed?
      return redirect_to session[:previous_url].present? ? session[:previous_url] : root_path, alert: Settings.spot.error.closed if @spot.closed? and (!user_signed_in? or @spot.user_id != current_user.id)
    end
  
    def set_pickup_area
      @areas = PickupArea.all
    end
end
