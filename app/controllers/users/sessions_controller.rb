class Users::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    if request.xhr?
      Devise::Models::Confirmable.module_eval do
        def active_for_authentication?
          super
        end
      end
      opts = auth_options
      opts[:recall] = "#{controller_path}#ajax_failure"
      self.resource = warden.authenticate!(opts)
      sign_in(resource_name, resource)
      @success = true
      @message_thread_id = GuestThread.get_message_thread_id(params[:user][:to_user_id], current_user.id)
      render 'users/sessions/create.js.erb'
    else
      Devise::Models::Confirmable.module_eval do
        def active_for_authentication?
          super && (!confirmation_required? || confirmed? || confirmation_period_valid?)
        end
      end
      super
    end
  end
  
  def ajax_failure
    @message = I18n.t('devise.failure.invalid', authentication_keys: 'email')
    @success = false
    render 'users/sessions/create.js.erb'
  end
  
  def omniauth_session
    session[:to_user_id] = params[:to_user_id]
    redirect_to omniauth_authorize_path(:user, 'facebook')
  end

  def destroy
    super
  end

  def after_sign_in_path_for(resource)
    #if (session[:previous_url] == root_path)
    #  super
    #else
      session[:previous_url] || root_path
    #end
  end
end

