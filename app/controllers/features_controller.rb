class FeaturesController < ApplicationController
  before_action :set_feature, only: [:show, :edit, :update, :destroy]
  before_action :set_contents

  # GET /features
  # GET /features.json

  # kamakura
  def index
  end
  
  def contents
    if request.xhr?
      render partial: "features/#{params[:device]}/#{params[:content_name]}"
    end
  end

  # kyoto
  def kyoto
  end

  def contents_kyoto
    @content_id = params[:id].to_i
    redirect_to root_path if @content_id > 9
  end
  
  # beppu
  def beppu
  end
  
  def contents_beppu
    @content_id = params[:id].to_i
    redirect_to root_path if @content_id > 9
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
