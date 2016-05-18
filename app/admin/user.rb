ActiveAdmin.register User do
  before_update do |user|
    @user_type_was = user.user_type_was
  end
  
  after_update do |user|
    if @user_type_was != user.user_type and user.support_guide?
      PairGuideMailer.become_support_guide_notification(user).deliver_now!
    end
  end
  
  permit_params :id,
                :email,
                :encrypted_password,
                :reset_password_token,
                :reset_password_sent_at,
                :remember_created_at,
                :sign_in_count,
                :current_sign_in_at,
                :last_sign_in_at,
                :current_sign_in_ip,
                :last_sign_in_ip,
                :confirmation_token,
                :confirmed_at,
                :confirmation_sent_at,
                :unconfirmed_email,
                :failed_attempts,
                :unlock_token,
                :locked_at,
                :created_at,
                :updated_at,
                :uid,
                :provider,
                :username,
                :soft_destroyed_at,
                :email_before_closed,
                :reason,
                :user_type
  form do |f|
    f.inputs do
      f.input :user_type,
              :as => :select,
              :include_blank => false,
              :collection => User.user_types.keys
    end
    f.actions
  end
  
  #set filters temporary as has_friendship works bad... 
  filter :auths
  filter :profile
  filter :profile_video
  filter :profile_identity
  filter :profile_bank
  filter :profile_keyword
  filter :pre_mail
  filter :profile_images
  filter :listings
  filter :message_thread_users
  filter :message_threads
  filter :ngevents
  filter :user_campaigns
  filter :campaigns
  filter :favorite_listing
  filter :favorite_users_of_from_user
  filter :favorite_users_of_to_user
  filter :email
  filter :reset_password_sent_at
  filter :reset_password_sent_at
  filter :remember_created_at
  filter :current_sign_in_at
  filter :last_sign_in_at
  filter :current_sign_in_ip
  filter :last_sign_in_ip
  #filter :confirmation_token
  filter :confirmed_at
  filter :confirmation_sent_at
  filter :unconfirmed_email
  filter :failed_attempts
  #filter :unlock_token
  filter :locked_at
  filter :created_at
  filter :updated_at
  filter :uid
  filter :provider
  filter :username
  filter :soft_destroyed_at
  filter :email_before_closed
  filter :reason
end
