module Api
  module V1
    class UsersController < Api::V1::BaseApiController
      def sign_in_via_email
        if sign_params['email'].blank?
          return render json: {
            success: false,
            error: 'invalid_params_no_email',
            msg: 'no email'
          },
          status: :bad_request
        end

        if sign_params['password'].blank?
          return render json: {
            success: false,
            error: 'invalid_params_no_password',
            msg: 'no password'
          },
          status: :bad_request
        end

        if sign_params['uuid'].present?
          p "has uuid #{uuid}"
          unless User.find_by(uuid: sign_params['uuid'])
            p "no user was found by uuid"
            return render json: { success: false, error: 'no_user_was_found', msg: 'no user was found by uuid' }, status: :bad_request
          end
          user = User.find_by(email: sign_params['email'], uuid: sign_params['uuid'])
        else
          p "no uuid"
          user = User.find_by(email: sign_params['email'])
          if user.blank?
            p 'no user was found'
            return render json: { success: false, error: 'no_user_was_found', msg: 'no user was found by email' }, status: :bad_request
          else
            p 'user exists'
            user.set_uuid_to_only_user
          end
        end
        p 'user'
        if user
          p sign_params[:password]
          if user.valid_password?(sign_params[:password])
            p 'authenticated by password'
            user.check_access_token
            p '==== after gen token ==='
            user.login_count_up
            p 'user'
            p user.inspect
            
            return render json: {
              user: user,
              profile: user.profile
            },
            status: :ok
          else
            return render json: { success: false, error: 'wrong_password', msg: 'could not sign in by the password' }, status: :bad_request
          end
        else
          return render json: { success: false, error: 'duplicated_email', msg: 'this email already have been used' }, status: :bad_request
        end
      end
      
      private
      def sign_params
        params.require(:user).permit(:email, :username, :password, :password_confirmation, :uuid)
      end
    end
  end
end