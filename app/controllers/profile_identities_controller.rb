class ProfileIdentitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile_identity, only: [:show, :edit, :update, :destroy]
  before_action :set_profile
  before_action :regulate_user, except: [:index, :create, :show]

  # GET /profile_images
  # GET /profile_images.json
  def index
    @profile_identities = ProfileIdentity.all
  end

  # GET /profile_images/1
  # GET /profile_images/1.json
  def show
  end

  # GET /profile_images/new
  def new
    @profile_identity = ProfileIdentity.new
  end

  # GET /profile_images/1/edit
  def edit
  end

  # POST /profile_images
  # POST /profile_images.json
  def create
    @profile_identity = ProfileIdentity.new(profile_identity_params)
    pp @profile_identity
    respond_to do |format|
      if @profile_identity.save
        ProfileIdentityMailer.send_id_uploaded_notification(@profile_identity).deliver_now!
        format.html { redirect_to edit_profile_profile_identity_path(@profile, @profile_identity), notice: Settings.profile_identities.save.success }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /profile_images/1
  # PATCH/PUT /profile_images/1.json
  def update
    @profile_identity = current_user.profile_identity
    @profile_identity.authorized = false if profile_identity_params[:image].present?
    
    respond_to do |format|
      if profile_identity_params[:image].present? and @profile_identity.update(profile_identity_params)
        ProfileIdentityMailer.send_id_uploaded_notification(@profile_identity).deliver_now!
        format.html { redirect_to edit_profile_profile_identity_path(@profile, @profile_identity), notice: Settings.profile_identities.save.success }
      else
        @profile_identity.errors.add(:image, :blank)
        format.html { render :edit }
      end
    end
  end

  # DELETE /profile_images/1
  # DELETE /profile_images/1.json
  def destroy
    @profile_identity.destroy
    respond_to do |format|
      format.html { redirect_to profile_identities_url, notice: 'Profile identity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_identity
      @profile_identity = ProfileIdentity.find(params[:id])
    end

    def set_profile
      @profile = Profile.find(params[:profile_id])
    end
  
    def regulate_user
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if @profile.user_id != current_user.id
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_identity_params
      params.require(:profile_identity).permit(:user_id, :profile_id, :image, :caption)
    end
end
