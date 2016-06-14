class GaCampaignTagsController < ApplicationController
  
  def show
    @link = GaCampaignTag.all.where(short_url: params[:short_url]).first
    redirect_to @link.present? ? @link.long_url : root_path
  end
end
