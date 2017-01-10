module Api
  module V1
    class BaseApiController < ApplicationController
      def valid_access?
        access_token = params['access_token']
        user_uuid = params['user_uuid']
        logger.info "valid_access?: access_token: #{access_token}, user_uuid: #{user_uuid}"

        return render json: { error: 'no_access_token', msg: 'No Access Token' }, status: :bad_request if access_token.blank?
        return render json: { error: 'no_uuid', msg: 'No User UUID' }, status: :bad_request if user_uuid.blank?

        current_user = User.find_by(access_token: access_token)
        if current_user.blank?
          return render json: { error: 'invalid_access_token', msg: 'Invalid Access Token' }, status: :unauthorized
        end

        if current_user.uuid != user_uuid
          return render json: { error: 'invalid_uuid', msg: 'Invalid User UUID' }, status: :bad_request
        end
      end
    end
  end
end