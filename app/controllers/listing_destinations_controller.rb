class ListingDestinationsController < ApplicationController
  before_action :set_listing_destination, only: [:show, :edit, :update, :destroy]

  # GET /listing_destinations
  # GET /listing_destinations.json
  def index
    @listing_destinations = ListingDestination.all
  end

  # GET /listing_destinations/1
  # GET /listing_destinations/1.json
  def show
  end

  # GET /listing_destinations/new
  def new
    @listing_destination = ListingDestination.new
  end

  # GET /listing_destinations/1/edit
  def edit
  end

  # POST /listing_destinations
  # POST /listing_destinations.json
  def create
    @listing_destination = ListingDestination.new(listing_destination_params)

    respond_to do |format|
      if @listing_destination.save
        format.html { redirect_to @listing_destination, notice: 'Listing destination was successfully created.' }
        format.json { render :show, status: :created, location: @listing_destination }
      else
        format.html { render :new }
        format.json { render json: @listing_destination.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listing_destinations/1
  # PATCH/PUT /listing_destinations/1.json
  def update
    respond_to do |format|
      if @listing_destination.update(listing_destination_params)
        format.html { redirect_to @listing_destination, notice: 'Listing destination was successfully updated.' }
        format.json { render :show, status: :ok, location: @listing_destination }
      else
        format.html { render :edit }
        format.json { render json: @listing_destination.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listing_destinations/1
  # DELETE /listing_destinations/1.json
  def destroy
    @listing_destination.destroy
    respond_to do |format|
      format.html { redirect_to listing_destinations_url, notice: 'Listing destination was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing_destination
      @listing_destination = ListingDestination.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_destination_params
      params[:listing_destination]
    end
end
