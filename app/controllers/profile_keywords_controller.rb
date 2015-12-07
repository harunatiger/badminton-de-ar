class ProfileKeywordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile_keyword, only: [:show, :edit, :update, :destroy]
  before_action :set_profile

  # GET /profile_keywords
  # GET /profile_keywords.json
  def index
    @profile_keywords = ProfileKeyword.all
  end

  # GET /profile_keywords/1
  # GET /profile_keywords/1.json
  def show
  end

  # GET /profile_keywords/new
  def new
    @profile_keyword = ProfileKeyword.new
    @tags = ActsAsTaggableOn::Tag.most_used
  end

  # GET /profile_keywords/1/edit
  def edit
    @tags = ActsAsTaggableOn::Tag.most_used
  end

  # POST /profile_keywords
  # POST /profile_keywords.json
  def create
    @profile_keyword = ProfileKeyword.new(profile_keyword_params)

    respond_to do |format|
      if @profile_keyword.save
        format.html { redirect_to profile_path(@profile.id), notice: Settings.profile_keywords.save.success }
        format.json { render :show, status: :created, location: @profile_keyword }
      else
        format.html { render :new }
        format.json { render json: @profile_keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profile_keywords/1
  # PATCH/PUT /profile_keywords/1.json
  def update
    respond_to do |format|
      if @profile_keyword.update(profile_keyword_params)
        format.html { redirect_to profile_path(@profile.id), notice: Settings.profile_keywords.save.success }
        format.json { render :show, status: :ok, location: @profile_keyword }
      else
        format.html { render :edit }
        format.json { render json: @profile_keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profile_keywords/1
  # DELETE /profile_keywords/1.json
  def destroy
    @profile_keyword.destroy
    respond_to do |format|
      format.html { redirect_to profile_keywords_url, notice: 'Profile keyword was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_keyword
      @profile_keyword = ProfileKeyword.find(params[:id])
    end
    
    def set_profile
      @profile = Profile.find(params[:profile_id])
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_keyword_params
      params.require(:profile_keyword).permit(:user_id, :profile_id )
    end
end
