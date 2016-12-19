class ListingDetailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing_detail, only: [:show, :edit, :update, :destroy]
  before_action :set_listing
  before_action :regulate_user

  def manage
    @listing_detail = ListingDetail.where(listing_id: @listing.id).first
    @listing_detail = ListingDetail.new unless @listing_detail
    @listing_detail.listing_detail_extra_costs.build if @listing_detail.listing_detail_extra_costs.blank?
  end

  # GET /listing_details
  # GET /listing_details.json
  def index
    @listing_details = ListingDetail.all
  end

  # GET /listing_details/1
  # GET /listing_details/1.json
  def show
  end

  # GET /listing_details/new
  def new
    @listing_detail = ListingDetail.new
  end

  # GET /listing_details/1/edit
  def edit
  end

  # POST /listing_details
  # POST /listing_details.json
  def create
    @listing_detail = ListingDetail.new(listing_detail_params)
    @listing_detail.set_lon_lat
    respond_to do |format|
      if @listing_detail.save
        format.html { redirect_to manage_listing_listing_details_path(@listing_detail), notice: Settings.listing_details.save.success }
        format.json { render :show, status: :created, location: @listing_detail }
      else
        flash.now[:alert] = Settings.listing_details.save.failure
        format.html { render 'manage' }
        format.json { render json: @listing_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listing_details/1
  # PATCH/PUT /listing_details/1.json
  def update
    respond_to do |format|
      @listing_detail.location = listing_detail_params['location']
      @listing_detail.set_lon_lat
      @listing_detail.register_detail = true
      if @listing_detail.update(listing_detail_params)
        format.html { redirect_to manage_listing_listing_details_path(@listing_detail), notice: Settings.listing_details.save.success }
        format.json { render :show, status: :ok, location: @listing_detail }
      else
        flash.now[:alert] = @listing_detail.errors.full_messages[0]
        #flash.now[:alert] = Settings.listing_details.save.failure
        format.html { render 'manage' }
        format.json { render json: @listing_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listing_details/1
  # DELETE /listing_details/1.json
  def destroy
    @listing_detail.destroy
    respond_to do |format|
      format.html { redirect_to listing_details_url, notice: 'Listing detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing_detail
      @listing_detail = ListingDetail.find(params[:id])
    end

    def set_listing
      @listing = Listing.find(params[:listing_id])
    end

    def regulate_user
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if @listing.user_id != current_user.id or !current_user.has_listing_admin_authority?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_detail_params
      params.require(:listing_detail).permit(:listing_id, :time_required, :min_num_of_people,
      :max_num_of_people, :price, :price_for_support, :price_for_both_guides, :space_option,
      :space_rental, :bicycle_option, :bicycle_rental, :other_option, :other_cost, :car_option,
      :car_rental, :gas, :highway, :parking, :guests_cost, :included_guests_cost, :zipcode,
      :location, :place, :place_memo, :condition, :refund_policy, :in_case_of_rain,
      :place_longitude, :place_latitude, :stop_if_rain,
      :transportation_cost_main, :transportation_cost_support,
      listing_detail_extra_costs_attributes: [:id, :listing_detail_id, :description, :price, :for_each, :_destroy])
    end
end
