class FeaturesController < ApplicationController
  before_action :set_feature, only: [:show, :edit, :update, :destroy]
  before_action :set_contents

  # GET /features
  # GET /features.json

  # kamakura
  def index
  end

  # kyoto
  def kyoto
  end

  def contents_kyoto
    @content_id = params[:id].to_i
    redirect_to root_path if @content_id > 9
  end

  def contents
    if request.xhr?
      render partial: "features/#{params[:device]}/#{params[:content_name]}"
    end
  end

  # GET /features/1
  # GET /features/1.json
  def show
  end

  # GET /features/new
  def new
    @feature = Feature.new
  end

  # GET /features/1/edit
  def edit
  end

  # POST /features
  # POST /features.json
  def create
    @feature = Feature.new(feature_params)

    respond_to do |format|
      if @feature.save
        format.html { redirect_to @feature, notice: 'Feature was successfully created.' }
        format.json { render :show, status: :created, location: @feature }
      else
        format.html { render :new }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /features/1
  # PATCH/PUT /features/1.json
  def update
    respond_to do |format|
      if @feature.update(feature_params)
        format.html { redirect_to @feature, notice: 'Feature was successfully updated.' }
        format.json { render :show, status: :ok, location: @feature }
      else
        format.html { render :edit }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /features/1
  # DELETE /features/1.json
  def destroy
    @feature.destroy
    respond_to do |format|
      format.html { redirect_to features_url, notice: 'Feature was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_contents
    @content01 = [320, 537, 158]
    @content02 = [96, 265, 544]
    @content03 = [321, 288, 312]
    @content04 = [333, 292, 410]
    @content05 = [211, 141, 282]
    @content06 = [313, 317, 324]
    @content07 = [145]
    @content08 = [339, 372, 188]
    @content09 = [315, 212, 95]
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature
      @feature = Feature.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_params
      params[:feature]
    end
end
