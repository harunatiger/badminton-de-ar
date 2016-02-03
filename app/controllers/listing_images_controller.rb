class ListingImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing_image, only: [:update, :destroy]
  before_action :set_listing

  def manage
    authorize! :manage, @listing
    @listing_images = @listing.listing_images.order_asc
  end
  
  def upload_video_cover_image
    respond_to do |format|
      if @listing.update(listing_params)
        format.js { @status = 'success' }
      else
        format.js { @status = 'failure' }
      end
    end
  end

  def create
    @listing_image = ListingImage.new(listing_image_params)
    count = ListingImage.where(listing_id: @listing.id).size
    @listing_image.order_num = count + 1
    respond_to do |format|
      if @listing_image.save
        format.js { @status = 'success' }
      else
        format.js { @status = 'failure' }
      end
    end
  end

  def update
    respond_to do |format|
      if @listing_image.update(listing_image_params)
        format.js { @status = 'success' }
      else
        format.js { @status = 'failure' }
      end
    end
  end

  def destroy
    @listing_image.remove_image!
    @listing_image.destroy
    @listing.listing_images.order('order_num').each_with_index do |listing_image, i|
      listing_image.update(order_num: i + 1)
    end
    @listing.unpublish_if_no_image
    respond_to do |format|
      format.html { redirect_to manage_listing_listing_images_path(@listing.id), notice: Settings.listing_images.delete.success }
      format.json { head :no_content }
    end
  end
  
  def destroy_cover_image
    @listing.remove_cover_image!
    @listing.save
    @listing.unpublish_if_no_image
    respond_to do |format|
      format.html { redirect_to manage_listing_listing_images_path(@listing.id), notice: Settings.listing_images.delete.success }
      format.json { head :no_content }
    end
  end
  
  def destroy_video
    @listing.remove_cover_video!
    @listing.save
    @listing.unpublish_if_no_image
    respond_to do |format|
      format.html { redirect_to manage_listing_listing_images_path(@listing.id), notice: Settings.listing_images.delete.success }
      format.json { head :no_content }
    end
  end
  
  def change_order
    if request.xhr?
      listing = Listing.find(params[:listing_id])
      image_from = ListingImage.where(listing_id: listing.id, order_num: params[:image_from]).first
      image_to = ListingImage.where(listing_id: listing.id, order_num: params[:image_to]).first
      image_from.update(order_num: params[:image_to])
      image_to.update(order_num: params[:image_from])
        
      @listing_images = listing.listing_images.order_asc
      render partial: 'images_list', locals: { listing_images: @listing_images}
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
  
    def listing_params
      params.require(:listing).permit(:cover_video, :cover_image)
    end

end
