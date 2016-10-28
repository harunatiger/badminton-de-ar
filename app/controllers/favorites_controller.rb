class FavoritesController < ApplicationController
  
  def index
  end
  
  def create
    if request.xhr?
      user = User.find(params[:user_id])
      favorite = Favorite.new(from_user_id: user.id, type: params[:type])
      
      if favorite.favorite_listing?
        favorite.listing_id = params[:target_id]
      elsif favorite.favorite_user?
        favorite.to_user_id = params[:target_id]
      elsif favorite.favorite_spot?
        favorite.spot_id = params[:target_id]
      end
      
      if favorite_old = favorite.old
        favorite_old.restore
        favorite = favorite_old
      else
        favorite.save
      end
      target = favorite.target
      render partial: 'shared/favorite', locals: { user: user, target: target}
    end
  end
  
  def destroy
    favorite = Favorite.find(params[:id])
    user = User.find(favorite.from_user_id)
    target = favorite.target
      
    favorite.soft_destroy
    if request.xhr?
      render partial: 'shared/favorite', locals: { user: user, target: target}
    else
      redirect_to :back
    end
  end
  
  def listings
    @favorite_listings = current_user.favorite_listings.page(params[:page]).per(6)
  end
  
  def users
    @favorite_users = current_user.favorite_users_of_from_user.page(params[:page]).per(6)
  end
  
  def spots
    @favorite_spots = FavoriteSpot.without_soft_destroyed.where(from_user_id: current_user.id).includes(:spot).page(params[:page]).per(6)
  end
end
