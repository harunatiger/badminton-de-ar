class ListingsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]
  #before_action :check_listing_status, only: [:index, :search]
  before_action :set_listing, only: [:show, :edit, :update, :destroy, :favorite_listing]
  before_action :set_listing_obj, only: [:publish, :unpublish, :copy, :preview]
  before_action :set_listing_related_data, only: [:show, :edit, :preview]
  before_action :set_message_thread, only: [:show]
  before_action :regulate_user, except: [:new, :index, :create, :show, :search, :favorite_listing]
  before_action :deleted_or_open_check, only: [:show, :edit]
  before_action :only_main_guide, only: [:new, :edit, :create, :update, :destroy, :publish, :unpublish, :copy]
  #before_action :set_favorite,  only: [:destroy]

  # GET /listings
  # GET /listings.json
  def index
    @listings = Listing.mine(current_user.id).without_soft_destroyed.order_by_updated_at_desc
    @pre_mail = current_user.pre_mail
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
    user_id = 0
    user_id = current_user.id if user_signed_in?
    BrowsingHistory.insert_record(user_id, @listing.id)
    ListingPv.add_count(@listing.id)
    @active_reservation = Reservation.active_reservation(user_id, @listing.user_id)
    @reviews = Review.this_listing(@listing).page(params[:page])
    @all_reviewed_count = Review.my_reviewed_count(@listing.user_id)
    @host_info = Profile.find_by(user_id: @listing.user_id)
    @host_image = ProfileImage.find_by(user_id: @listing.user_id)
    #@profiles = Profile.main_and_support_guides.where.not(id: @host_info.id)
    @message = Message.new
    #@wishlists = Wishlist.mine(current_user).order_by_created_at_desc
    gon.ngdates = Ngevent.get_ngdates(@listing)
    gon.ngweeks = NgeventWeek.get_ngweeks_from_listing(@listing).pluck(:dow)
    gon.listing = @listing.listing_detail
    @reservation = Reservation.new
    @profile_keyword = ProfileKeyword.where(user_id: @listing.user_id, profile_id: Profile.where(user_id: @listing.user_id).pluck(:id).first).keyword_limit
    gon.keywords = @profile_keyword
    @announcement = Announcement.display_at('listing').first
  end

  def new
    @listing = Listing.new
    @listing.build_listing_detail
    @listing.listing_destinations.build
    @areas = PickupArea.all
  end

  def edit
    @listing.build_listing_detail if @listing.listing_detail.blank?
    @listing.listing_destinations.build if @listing.listing_destinations.blank?
    @areas = PickupArea.all
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = Listing.new(listing_params)
    @listing.listing_detail.register_detail = false
    #if @listing.set_lon_lat
    respond_to do |format|
      if @listing.save
        format.html { redirect_to manage_listing_listing_images_path(@listing.id), notice: Settings.listings.save.success }
      else
        #@categories = PickupCategory.all
        #@tags = PickupTag.all
        @areas = PickupArea.all
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
    respond_to do |format|
      if @listing.update(listing_params)
          format.html { redirect_to manage_listing_listing_images_path(@listing.id), notice: Settings.listings.save.success }
      else
        @categories = PickupCategory.all
        @tags = PickupTag.all
        @areas = PickupArea.all
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
    @listing.delete_children
    @listing.soft_destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: Settings.listings.destroy.success }
      format.json { head :no_content }
    end
  end

  def publish
    return redirect_to new_profile_path unless Profile.exists?(user_id: @listing.user_id)
    respond_to do |format|
      if @listing.publish
        format.html { redirect_to listings_path(current_user), notice: Settings.listings.publish.success }
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

  def copy
    if @listing_copied = @listing.dup_all
      redirect_to edit_listing_path(@listing_copied), notice: Settings.listings.copy.success
    else
      redirect_to listings_path, alert: Settings.listings.copy.failure
    end
  end

  def preview
    @reviews = Review.this_listing(@listing).page(params[:page])
    @all_reviewed_count = Review.my_reviewed_count(@listing.user_id)
    @host_info = Profile.find_by(user_id: @listing.user_id)
    @host_image = ProfileImage.find_by(user_id: @listing.user_id)
    @profiles = Profile.guides.where.not(id: @host_info.id)
    gon.ngdates = Ngevent.get_ngdates(@listing)
    gon.ngweeks = NgeventWeek.get_ngweeks_from_listing(@listing).pluck(:dow)
    gon.listing = @listing.listing_detail
    @reservation = Reservation.new
    @profile_keyword = ProfileKeyword.where(user_id: @listing.user_id, profile_id: Profile.where(user_id: @listing.user_id).pluck(:id).first).keyword_limit
    gon.keywords = @profile_keyword
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
      @listing_images = ListingImage.where(listing_id: @listing.id).image_limit
    end

    def set_message_thread
      if current_user
        if res = GuestThread.exists_thread?(@listing.user_id, current_user.id)
          @message_thread = GuestThread.find(res)
        end
      end
    end

    def regulate_user
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if @listing.user_id != current_user.id
    end
  
    def only_main_guide
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure unless current_user.main_guide?
    end

    def deleted_or_open_check
      return redirect_to session[:previous_url].present? ? session[:previous_url] : root_path, alert: Settings.listings.error.deleted_listing_id if @listing.soft_destroyed?
      return redirect_to session[:previous_url].present? ? session[:previous_url] : root_path, alert: Settings.listings.error.closed if !@listing.open and (!user_signed_in? or @listing.user_id != current_user.id)
    end

    #def set_favorite
    #  @favorite_listing = FavoriteListing.where(listing_id: @listing.id)
    #end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      params.require(:listing).permit(
        :user_id, :evaluation_count,
        :ave_total, :ave_accuracy, :ave_communication, :ave_cleanliness,
        :ave_location, :ave_check_in, :ave_cost_performance, :open,
        :zipcode, :location, :longitude, :latitude, :delivery_flg, :price,
        :description, :recommend1, :recommend2, :recommend3,
        :interview1, :interview2, :interview3, :overview, :notes,
        :title, :capacity, :direction, :schedule, :listing_images,
        :cover_video, :cover_video_caption,
        listing_image_attributes: [:listing_id, :image, :order, :capacity], category_ids: [],
        language_ids: [], pickup_ids: [],
        listing_detail_attributes: [:id, :place_memo, :condition, :stop_if_rain, :in_case_of_rain ],
        listing_destinations_attributes: [:id, :location, :longitude, :latitude, :_destroy ]
        )
    end
end
