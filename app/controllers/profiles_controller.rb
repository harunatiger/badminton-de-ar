class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :regulate_user!, only: [:edit]
  before_action :set_profile, only: [:show, :edit, :update, :destroy, :self_introduction]
  before_action :set_pair_guide, only: [:show]
  before_action :set_message_thread, only: [:show]
  before_action :get_progress, only: [:edit, :self_introduction, :new]

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @listings = Listing.mine(@profile.user_id).opened.includes(:listing_detail).order_by_updated_at_desc
    gon.listings = @listings.map{|l| l.listing_detail}
    #@reviewed = Review.they_do(@profile.user_id).order_by_updated_at_desc
    @reviewed = Review.they_do(@profile.user_id).joins(:reservation).merge(Reservation.review_open?).order_by_updated_at_desc
    @reviewed_as_guest = Review.i_do(@profile.user_id).joins(:reservation).merge(Reservation.review_open?).order_by_updated_at_desc.includes(:review_reply)
    @profile_keyword = ProfileKeyword.where(user_id: @profile.user_id, profile_id: @profile.id).keyword_limit
    gon.keywords = @profile_keyword
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
  end

  def self_introduction
    @tags = ActsAsTaggableOn::Tag.most_used
    flash.now[:notice] = Settings.profile.send_message if params[:send_message] == 'yes'
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
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      para = profile_params
      if para[:municipality]
        para[:location] = para[:municipality] + ' ' + para[:prefecture]
      end
      if @profile.update(para)
        Profile.set_percentage(@profile.user_id)
        format.html { redirect_to @profile, notice: Settings.profile.save.success }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    def set_pair_guide
      @profiles = Profile.guides.where.not(id: @profile.id)
    end

    def regulate_user!
      unless current_user.profile.id == params[:id].to_i
        redirect_to dashboard_path, notice: Settings.regulate_user.user_id.failure
      end
    end

    def set_message_thread
      if current_user
        msg_params = Hash['to_user_id' => @profile.user_id,'from_user_id' => current_user.id]
        if res = MessageThread.exists_thread?(msg_params)
          @message_thread = MessageThread.find(res)
        end
      end
    end

    def get_progress
      @progress = Profile.get_percentage(@profile.user_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(
        :id, :user_id, :first_name, :last_name, :birthday,
        :phone, :phone_verification, :country, :location, :self_introduction, :tag_list,
        :school, :work, :timezone, :gender, :zipcode, :prefecture, :municipality, :other_address,
        :listing_count, :wishlist_count, :bookmark_count, :reviewed_count,
        :reservation_count,
        :ave_total, :ave_accuracy, :ave_communication, :ave_cleanliness, :ave_location,
        :ave_check_in, :ave_cost_performance, :created_at, :updated_at, category_ids: [],language_ids: [])
    end
end
