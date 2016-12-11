class ListingUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing
  before_action :set_listing_user, only: [:destroy, :accept, :add_receptionist]
  before_action :regulate_user, only: [:destroy]

  # GET /listing_users
  # GET /listing_users.json
  def index
    @pending_members = ListingUser.pending_members(@listing.id)
    @receptionists = ListingUser.receptionist_members(@listing.id)
    @nomal_members = ListingUser.nomal_members(@listing.id)
  end

  # POST /listing_users
  # POST /listing_users.json
  def create
    @listing_user = ListingUser.new(listing_user_params)

    respond_to do |format|
      if @listing_user.save
        format.html { redirect_to listings_path, notice: Settings.listing_users.save.success }
        format.json { render :show, status: :created, location: @listing_user }
      else
        format.html { redirect_to listing_path(@listing), alert: Settings.listing_users.save.failure }
        format.json { render json: @listing_user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def accept
    respond_to do |format|
      if @listing_user.member!
        format.html { redirect_to listing_listing_users_path(@listing), notice: Settings.listing_users.accept.success }
        format.json { render :show, status: :ok, location: @listing_user }
      else
        format.html { redirect_to listing_listing_users_path(@listing), alert: Settings.listing_users.accept.failure }
        format.json { render json: @listing_user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def add_receptionist
    respond_to do |format|
      if @listing_user.receptionist!
        format.html { redirect_to listing_listing_users_path(@listing), notice: Settings.listing_users.add_receptionist.success }
        format.json { render :show, status: :ok, location: @listing_user }
      else
        format.html { redirect_to listing_listing_users_path(@listing), alert: Settings.listing_users.add_receptionist.failure }
        format.json { render json: @listing_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listing_users/1
  # DELETE /listing_users/1.json
  def destroy
    @listing_user.destroy
    respond_to do |format|
      format.html { redirect_to listing_listing_users_path(@listing), notice: Settings.listing_users.destroy.success }
      format.json { head :no_content }
    end
  end

  private
    def set_listing
      @listing = Listing.find_by_id(params[:listing_id])
      return redirect_to root_path, notice: Settings.listings.error.invalid_listing_id if @listing.blank?
    end
    
    def set_listing_user
      @listing_user = ListingUser.find(params[:id])
    end
    
    def regulate_user
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if @listing.user_id != current_user.id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_user_params
      params.require(:listing_user).permit(:listing_id, :user_id, :user_status, :request_message)
    end
end
