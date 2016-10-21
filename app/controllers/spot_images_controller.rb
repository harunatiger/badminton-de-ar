class SpotImagesController < ApplicationController
  before_action :set_spot_image, only: [:show, :edit, :update, :destroy]

  # GET /spot_images
  # GET /spot_images.json
  def index
    @spot_images = SpotImage.all
  end

  # GET /spot_images/1
  # GET /spot_images/1.json
  def show
  end

  # GET /spot_images/new
  def new
    @spot_image = SpotImage.new
  end

  # GET /spot_images/1/edit
  def edit
  end

  # POST /spot_images
  # POST /spot_images.json
  def create
    @spot_image = SpotImage.new(spot_image_params)

    respond_to do |format|
      if @spot_image.save
        format.html { redirect_to @spot_image, notice: 'Spot image was successfully created.' }
        format.json { render :show, status: :created, location: @spot_image }
      else
        format.html { render :new }
        format.json { render json: @spot_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spot_images/1
  # PATCH/PUT /spot_images/1.json
  def update
    respond_to do |format|
      if @spot_image.update(spot_image_params)
        format.html { redirect_to @spot_image, notice: 'Spot image was successfully updated.' }
        format.json { render :show, status: :ok, location: @spot_image }
      else
        format.html { render :edit }
        format.json { render json: @spot_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spot_images/1
  # DELETE /spot_images/1.json
  def destroy
    @spot_image.destroy
    respond_to do |format|
      format.html { redirect_to spot_images_url, notice: 'Spot image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spot_image
      @spot_image = SpotImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spot_image_params
      params[:spot_image]
    end
end
