class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_profile, only: [:show, :edit, :update, :destroy, :self_introduction, :favorite_user, :read_more_reviews]
  #before_action :set_pair_guide, only: [:show]
  before_action :set_message_thread, only: [:show]
  before_action :get_progress, only: [:edit, :self_introduction, :new]
  before_action :regulate_user, except: [:new, :index, :create, :show, :favorite_user, :delete_category, :read_more_reviews]
  before_action :deleted_check, only: [:show, :edit]
  before_action :set_reviews, only: [:show]

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @listings = Listing.mine(@profile.user_id).opened.without_soft_destroyed.includes(:listing_detail).order_by_updated_at_desc
    gon.listings = ListingDetail.where(listing_id: @listings.map{|l| l.id}).where.not('place_longitude = 0 and place_latitude = 0')
    @profile_keyword = ProfileKeyword.where(user_id: @profile.user_id, profile_id: @profile.id).keyword_limit
    gon.keywords = @profile_keyword
  end
  
  def read_more_reviews
    if request.xhr?
      count = params[:current_count].to_i + Settings.profile.review_display_count
      if params[:reviewed_as] == 'guide'
        reviewed = Review.reviewed_as_guide(@profile.user_id)
        @reviewed = reviewed.limit(count).order_by_created_at_desc
        return render partial: '/profiles/show/reviewed', locals: { reviewed: @reviewed, reviewed_count: reviewed.count }
      else
        reviewed_as_guest = Review.reviewed_as_guest(@profile.user_id)
        @reviewed_as_guest = reviewed_as_guest.limit(count).order_by_created_at_desc
        return render partial: '/profiles/show/reviewed_as_guest', locals: { reviewed_as_guest: @reviewed_as_guest, reviewed_as_guest_count: reviewed_as_guest.count }
      end
    end
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
    @profile.profile_countries.build if @profile.profile_countries.blank?
    flash.now[:notice] = Settings.profile.send_message if params[:send_message] == 'yes'
  end

  def self_introduction
    @tags = ActsAsTaggableOn::Tag.most_used
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)
    if profile_params[:municipality]
      @profile.location = profile_params[:municipality] + ' ' + profile_params[:prefecture]
    end
    respond_to do |format|
      if @profile.save
        Profile.set_percentage(@profile.user_id)
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        flash.now[:alert] = Settings.profile.save.failure
        format.html { render 'new' }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    para = Profile.set_up_update_params(profile_params)
    para[:enable_strict_validation] = true if params[:page_self_introduction].blank?
    respond_to do |format|
      if @profile.update(para)
        Profile.set_percentage(@profile.user_id)
        format.html { redirect_to params[:page_self_introduction].present? ? self_introduction_profile_path(@profile) : edit_profile_path(@profile), notice: Settings.profile.save.success }
        #format.mobile { redirect_to @profile, notice: Settings.profile.save.success }
        format.json { render :show, status: :ok, location: @profile }
      else
        #flash.now[:alert] = Settings.profile.save.failure
        format.html { render 'edit' }
        #format.mobile { render 'edit' }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def review

  end

  def introduction

  end

  def favorite_user
    if current_user.favorite_user?(@profile)
      current_user.favorite_users_of_from_user.where(to_user_id: @profile.user_id).destroy_all
      post = 'delete'
    else
      if current_user.favorite_users_of_from_user.create(to_user_id: @profile.user_id)
        status = 'success'
        post = 'create'
      else
        status = 'error'
      end
    end
    @reviewed = Review.reviewed_as_guide(@profile.user_id)
    @reviewed_as_guest = Review.reviewed_as_guest(@profile.user_id)
    reviewed_count = @reviewed.count
    reviewed_as_guest_count = @reviewed_as_guest.count
    html = render_to_string partial: '/profiles/show/user_card', locals: { profile: @profile, reviewed_count: reviewed_count + reviewed_as_guest_count }
    render json: { status: status, html: html , post: post}
  end
  
  def delete_category
    if request.xhr?
      profile_categories = ProfileCategory.where(profile_id: current_user.profile.id)
      result = false
      result = profile_categories.where(category_id: params[:category_id]).destroy_all if profile_categories.present?
      return render text: result
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    #def set_pair_guide
    #  @profiles = Profile.guides.where.not(id: @profile.id)
    #end

    def set_message_thread
      if current_user
        if res = GuestThread.exists_thread?(@profile.user_id, current_user.id)
          @message_thread = GuestThread.find(res)
        end
      end
    end

    def get_progress
      @progress = Profile.get_percentage(@profile.user_id)
    end

    def regulate_user
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if @profile.user_id != current_user.id
    end

    def deleted_check
      return redirect_to session[:previous_url].present? ? session[:previous_url] : root_path, alert: Settings.profile.deleted_profile_id if @profile.soft_destroyed?
    end
  
    def set_reviews
      reviewed = Review.reviewed_as_guide(@profile.user_id)
      @reviewed_count = reviewed.count
      @reviewed = reviewed.limit(Settings.profile.review_display_count).order_by_created_at_desc
      
      reviewed_as_guest = Review.reviewed_as_guest(@profile.user_id)
      @reviewed_as_guest_count = reviewed_as_guest.count
      @reviewed_as_guest = reviewed_as_guest.limit(Settings.profile.review_display_count).order_by_created_at_desc
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(
        :id, :user_id, :first_name, :last_name, :birthday,
        :phone, :phone_verification, :country, :location, :self_introduction, :tag_list,
        :school, :work, :timezone, :gender, :zipcode, :prefecture, :municipality, :other_address,:free_field, 
        :listing_count, :wishlist_count, :bookmark_count, :reviewed_count,
        :reservation_count,
        :ave_total, :ave_accuracy, :ave_communication, :ave_cleanliness, :ave_location,
        :ave_check_in, :ave_cost_performance, :created_at, :updated_at, category_ids: [],language_ids: [], profile_categories_attributes: [:id, :category_id, :tag_list => []], profile_countries_attributes: [:id, :country, :_destroy])
    end
end
