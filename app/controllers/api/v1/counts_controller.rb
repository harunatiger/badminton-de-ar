module Api
  module V1
    class CountsController < Api::V1::BaseApiController
      def add
        count = Count.find_by_player_id(params[:player_id].to_i)
        num = params[:count].to_i
        if count.blank?
          count = Count.create(player_id: params[:player_id].to_i, count: 0)
        end
        count.count += num
        count.save
        return render json: { }, status: :ok
      end
    end
  end
end