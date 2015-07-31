class ListingImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing_image, only: [:update, :destroy]
  before_action :set_listing

  def manage
    listing_images = ListingImage.records(@listing.id)
    @listing_images = ListingImageCollection.new({},@listing.id)
  end
  
  def update_all
    @listing_images = ListingImageCollection.new(listing_image_collection_params, @listing.id)
    if @listing_images.save
      redirect_to manage_listing_listing_images_path(@listing.id), notice: Settings.listing_images.save.success
    else
      redirect_to manage_listing_listing_images_path(@listing.id), notice: Settings.listing_images.save.failure
    end
  end

  def create
    @listing_image = ListingImage.new(listing_image_params)
    count = ListingImage.where(listing_id: @listing.id).size
    @listing_image.order_num = count
    if @listing_image.save
      redirect_to manage_listing_listing_images_path(@listing.id), notice: Settings.listing_images.save.success
      #render json: { success: true, status: :created, location: @listing_image }
    else
      redirect_to manage_listing_listing_images_path(@listing.id), notice: Settings.listing_images.save.failure
      #render json: { success: false, errors: @listing_image.errors, status: :unprocessable_entity }
    end
  end

  def update
    if @listing_image.update(listing_image_params)
      redirect_to manage_listing_listing_images_path(@listing.id), notice: Settings.listing_images.save.success
      #render json: { success: true, status: :ok, location: @listing_image, notice: Settings.listing_images.save.success }
    else
      redirect_to manage_listing_listing_images_path(@listing.id), notice: Settings.listing_images.save.failure
      #render json: { success: false, errors: @listing_image.errors, status: :unprocessable_entity, notice: Settings.listing_images.save.failure }
    end
  end

  def destroy
    @listing_image.destroy
    respond_to do |format|
      format.html { redirect_to listing_images_url, notice: 'ListingImage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_listing_image
      @listing_image = ListingImage.find(params[:id])
    end

    def set_listing
      @listing = Listing.find(params[:listing_id])
    end

    def listing_image_params
      params.require(:listing_image).permit(:listing_id, :image, :caption)
    end
  
    def listing_image_collection_params
      params
        .require(:listing_image_collection)
      .permit(listing_images_attributes: [:id, :listing_id, :image, :caption, :description])
    end

end
