class ListingVideosController < ApplicationController
  before_action :set_listing_video, only: [:show, :edit, :update, :destroy]

  # GET /listing_videos
  # GET /listing_videos.json
  def index
    @listing_videos = ListingVideo.all
  end

  # GET /listing_videos/1
  # GET /listing_videos/1.json
  def show
  end

  # GET /listing_videos/new
  def new
    @listing_video = ListingVideo.new
  end

  # GET /listing_videos/1/edit
  def edit
  end

  # POST /listing_videos
  # POST /listing_videos.json
  def create
    @listing_video = ListingVideo.new(listing_video_params)

    respond_to do |format|
      if @listing_video.save
        format.html { redirect_to @listing_video, notice: 'Listing video was successfully created.' }
        format.json { render :show, status: :created, location: @listing_video }
      else
        format.html { render :new }
        format.json { render json: @listing_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listing_videos/1
  # PATCH/PUT /listing_videos/1.json
  def update
    respond_to do |format|
      if @listing_video.update(listing_video_params)
        format.html { redirect_to @listing_video, notice: 'Listing video was successfully updated.' }
        format.json { render :show, status: :ok, location: @listing_video }
      else
        format.html { render :edit }
        format.json { render json: @listing_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listing_videos/1
  # DELETE /listing_videos/1.json
  def destroy
    @listing_video.destroy
    respond_to do |format|
      format.html { redirect_to listing_videos_url, notice: 'Listing video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing_video
      @listing_video = ListingVideo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_video_params
      params[:listing_video]
    end
end
