class FavoriteUsersController < ApplicationController
  before_action :set_favorite_user, only: [:destroy]

  def index
    @favorite_users = current_user.favorite_users_of_from_user.page(params[:page]).per(6)
  end

  def destroy
    @favorite_user.soft_destroy
    respond_to do |format|
      format.html { redirect_to favorite_users_path }
      format.json { head :no_content }
    end
  end

  private
    def set_favorite_user
      @favorite_user = FavoriteUser.find(params[:id])
    end

end
