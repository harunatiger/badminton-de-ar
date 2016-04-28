class ListingImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing_image, only: [:update, :destroy, :set_category]
  before_action :set_listing
  before_action :regulate_user

  def manage
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
    count = ListingImage.where(listing_id: @listing.id).size
    if count > Settings.listing_images.max_count
      respond_to do |format|
        format.js { @status = 'count_over' }
      end
    end
    
    ActiveRecord::Base.transaction do
      listing_images = []
      create_listing_image_params[:image].each do |image|
        count += 1
        @listing_image = ListingImage.new(listing_id: @listing.id, image: image, order_num: count)
        @listing_image.save!
      end
    end
    respond_to do |format|
      format.js { @status = 'success' }
    end
    
    rescue => e
    respond_to do |format|
      format.js { @status = 'failure' }
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
        
      @listing_images = listing.listing_images
      render partial: 'images_list', locals: { cover_video: listing.cover_video, listing_images: @listing_images.order_asc}
    end
  end
  
  def set_category
    if request.xhr?
      distance = ListingImage.distance(params[:category], @listing_image.category)
      params[:category] = '' if distance == 0
      if @listing_image.update(category: params[:category])
        return render text: distance
        #return render partial: 'shared/modals/set_listing_image', locals: { listing: @listing, listing_image: @listing_image}
      else
        raise
      end
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
  
    def create_listing_image_params
      params.require(:listing_image).permit(:listing_id, image: [])
    end
  
    def listing_params
      params.require(:listing).permit(:cover_video)
    end
  
    def regulate_user
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if @listing.user_id != current_user.id or !current_user.main_guide?
    end

end
