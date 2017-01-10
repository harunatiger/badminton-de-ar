module Api
  module V1
    class ListingsController < Api::V1::BaseApiController
      before_action :valid_access?
      def index
        user = User.find_by_uuid(params[:user_uuid])
        @listings = Listing.mine(user.id).without_soft_destroyed.order_by_updated_at_desc
        render json: @listings.to_json(include: [:listing_detail, :listing_images]), status: 200
      end
    end
  end
end