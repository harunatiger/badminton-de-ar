class ListingsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_action :set_listing_obj, only: [:publish, :unpublish]
  before_action :set_listing_related_data, only: [:show, :edit]
  before_action :set_message_thread, only: [:show]

  # GET /listings
  # GET /listings.json
  def index
    @listings = Listing.mine(current_user.id).order_by_updated_at_desc
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
    user_id = 0
    user_id = current_user.id if user_signed_in?
    BrowsingHistory.insert_record(user_id, @listing.id)
    ListingPv.add_count(@listing.id)
    @active_reservation = Reservation.active_reservation(user_id, @listing.user_id)
    @reviews = Review.this_listing(@listing.id).joins(:reservation).merge(Reservation.review_open?).order_by_created_at_desc.page(params[:page])
    @host_info = Profile.find_by(user_id: @listing.user_id)
    @host_image = ProfileImage.find_by(user_id: @listing.user_id)
    @profiles = Profile.guides.where.not(id: @host_info.id)
    @message = Message.new
    #@wishlists = Wishlist.mine(current_user).order_by_created_at_desc
    gon.listing = @listing.listing_detail
    @reservation = Reservation.new
  end

  def new
    @listing = Listing.new
    @categories = PickupCategory.all
    @tags = PickupTag.all
    @areas = PickupArea.all
  end

  def edit
    @categories = PickupCategory.all
    @tags = PickupTag.all
    @areas = PickupArea.all
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = Listing.new(listing_params)
    #if @listing.set_lon_lat
    respond_to do |format|
      if @listing.save
        format.html { redirect_to manage_listing_listing_images_path(@listing.id), notice: Settings.listings.save.success }
      else
        flash.now[:alert] = Settings.listings.save.failure
        format.html { render :new}
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
    #else
      #return render :new, notice: Settings.listings.set_lon_lat.error
    #end
  end

  # PATCH/PUT /listings/1
  # PATCH/PUT /listings/1.json
  def update
    #@listing.location = listing_params['location']
    #if @listing.set_lon_lat
    respond_to do |format|
      if @listing.update(listing_params)
          format.html { redirect_to manage_listing_listing_images_path(@listing.id), notice: Settings.listings.save.success }
      else
        flash.now[:alert] = Settings.listings.save.failure
        format.html { render :edit}
      end
    end
    #else
      #return render json: { success: false, errors: 'lonlat_failure'}
    #end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    listings = Listing.search(search_params).opened.page(params[:page])
    gon.listings = listings
    @hit_count = listings.count
    @listings = listings.page(params[:page]).per(10)
    @conditions = search_params
  end

  def publish
    return redirect_to new_profile_path unless Profile.exists?(user_id: @listing.user_id)
    respond_to do |format|
      if @listing.publish
        format.html { redirect_to listing_path(@listing), notice: Settings.listings.publish.success }
      else
        format.html { redirect_to edit_listing_path(@listing), notice: Settings.listings.publush.failure }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def unpublish
    respond_to do |format|
      if @listing.unpublish
        format.html { redirect_to edit_listing_path(@listing), notice: Settings.listings.unpublish.success }
      else
        format.html { redirect_to edit_listing_path(@listing), notice: Settings.listings.unpublush.failure }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.where(id: params[:id]).first
      return redirect_to root_path, notice: Settings.listings.error.invalid_listing_id if @listing.blank?
    end

    def set_listing_obj
      @listing = Listing.find(params[:listing_id])
    end

    def set_listing_related_data
      @listing_images = ListingImage.where(listing_id: @listing.id).limit_5
      @confection = Confection.find_by(listing_id: @listing.id)
      @dress_code = DressCode.find_by(listing_id: @listing.id)
      @tool = Tool.find_by(listing_id: @listing.id)
    end
  
    def set_message_thread
      if current_user
        msg_params = Hash['to_user_id' => @listing.user_id,'from_user_id' => current_user.id]
        if res = MessageThread.exists_thread?(msg_params)
          @message_thread = MessageThread.find(res)
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      params.require(:listing).permit(
        :user_id, :evaluation_count, 
        :ave_total, :ave_accuracy, :ave_communication, :ave_cleanliness, 
        :ave_location, :ave_check_in, :ave_cost_performance, :open, 
        :zipcode, :location, :longitude, :latitude, :delivery_flg, :price, 
        :description, :title, :capacity, :direction, :schedule, :listing_images,
        :cover_image, :cover_image_caption, :cover_video, :cover_video_caption, 
        listing_image_attributes: [:listing_id, :image, :order, :capacity], category_ids: [],
        language_ids: [], pickup_ids: [])
    end

    def search_params
      params.require(:search).permit(:location, :schedule, :num_of_guest, :price, :confection, :tool, :wafuku, :keywords, :where)
    end
end
