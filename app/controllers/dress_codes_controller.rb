class DressCodesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_dress_code, only: [:update, :destroy]
  before_action :set_listing

  def manage
    dress_codes = DressCode.records(params[:listing_id])
    if dress_codes.size.zero?
      @dress_code = DressCode.new
    else
      @dress_code = dress_codes[0]
    end
  end

  def create
    @dress_code = DressCode.new(dress_code_params)
    if @dress_code.save
      redirect_to manage_listing_dress_codes_path(@listing.id), notice: Settings.dress_codes.save.success
      #render json: { success: true, status: :created, location: @dress_code }
    else
      redirect_to manage_listing_dress_codes_path(@listing.id), notice: Settings.dress_codes.save.failure
      #render json: { success: false, errors: @dress_code.errors, status: :unprocessable_entity }
    end
  end

  def update
    if @dress_code.update(dress_code_params)
      redirect_to manage_listing_dress_codes_path(@listing.id), notice: Settings.dress_codes.save.success
      #render json: { success: true, status: :created, location: @dress_code }
    else
      redirect_to manage_listing_dress_codes_path(@listing.id), notice: Settings.dress_codes.save.failure
      #render json: { success: false, errors: @dress_code.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    @dress_code.destroy
    respond_to do |format|
      format.html { redirect_to dress_codes_url, notice: 'Dress code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_dress_code
      @dress_code = DressCode.find(params[:id])
    end

    def set_listing
      @listing = Listing.find(params[:listing_id])
    end

    def dress_code_params
      params.require(:dress_code).permit(:listing_id, :wafuku, :note)
    end
end
