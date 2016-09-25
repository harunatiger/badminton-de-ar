Rails.application.routes.draw do

  resources :features, only: [:index] do
    collection do
      get 'contents'
    end
  end
  
  resources :ga_campaign_tags, param: :short_url, path: 'cp', only: [:show]
  
  mount Ckeditor::Engine => '/ckeditor'

  get 'static_pages/cancel_policy_en'
  get 'static_pages/service_agreement_en'
  get 'static_pages/specific_commercial_transactions_en'
  get 'static_pages/privacy_policy_en'
  get 'static_pages/cancel_policy_jp'
  get 'static_pages/service_agreement_jp'
  get 'static_pages/specific_commercial_transactions_jp'
  get 'static_pages/privacy_policy_jp'
  get 'static_pages/about'
  get 'static_pages/plan4U'
  get 'static_pages/three_reasons'
  get 'static_pages/our_partners'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin::Devise.config
  begin
    ActiveAdmin.routes(self)
  rescue Exception => e
    puts "ActiveAdmin: #{e.class}: #{e}"
  end

  resources :announcements, param: :page_url, only: [:show, :index]
  resources :reports, only: [:create]

  resources :profiles do
    resources :profile_images, only: [:show, :create, :update, :destroy] do
      get 'manage', on: :collection
      put 'change_order', on: :collection
      post 'create_cover_image', on: :collection
      post 'check_validation', on: :collection
    end
    resources :profile_videos, only: [:destroy] do
      patch 'upload_video', on: :collection
    end
    resources :profile_banks
    resources :profile_identities, only: [:new, :edit, :create, :update, :destroy]
    
    member do
      get 'self_introduction',    action: 'self_introduction'
      get 'read_more_reviews',    action: 'read_more_reviews'
    end
    collection do
      delete 'delete_category',    action: 'delete_category'
    end
  end
  
  resources :withdrawals, only: [:index] do
    post 'apply', on: :collection
  end

  get 'dashboard'                           => 'dashboard#index'
  get 'dashboard/host_reservation_manager'  => 'dashboard#host_reservation_manager'
  get 'dashboard/guest_reservation_manager' => 'dashboard#guest_reservation_manager'
  get 'dashboard/favorite_histories' => 'dashboard#favorite_histories'
  post 'dashboard/get_chart_data' => 'dashboard#get_chart_data'
  # get 'reviews'                             => 'profiles#review', as: 'user_review'
  # get 'introductions'                       => 'profiles#introduction', as: 'introduction'
  #get 'pickups/show/:type/:id'                    => 'listing_pickups#show', as: 'pickups_list'

  resources :message_threads, except: [:edit] do
    get 'talk_to_me', on: :member
    post 'what_talk_about', on: :member
    patch 'start_planning', on: :member
    get 'change_language', on: :collection
  end

  resources :messages do
    collection do
      post 'send_message'
      get 'show_preview'
      get 'download_attached_file'
    end
  end

  resources :pre_mails, only: [:create]
  resources :listings do
    collection do
      get 'search',        action: 'search'
      get 'search_result', action: 'search_result'
      get 'page/:page',    action: 'index'
    end
    resources :listing_images, only: [:show, :create, :update, :destroy] do
      get 'manage', on: :collection
      post 'upload_video_cover_image', on: :collection
      put 'change_order', on: :collection
      delete 'destroy_video', on: :collection
      post 'set_category', on: :member
    end
    resources :listing_details, only: [:show, :create, :update, :destroy] do
      get 'manage', on: :collection
    end
    get 'publish',   action: 'publish',   as: 'publish'
    get 'unpublish', action: 'unpublish', as: 'unpublish'
    get 'preview'
    post 'copy', action: 'copy', as: 'copy'
    resources :ngevents, only: [:create] do
      get 'listing_ngdays', on: :collection
      get 'listing_reservation_ngdays', on: :collection
      get 'listing_request_ngdays', on: :collection
      get 'reservation_except_listing_ngdays', on: :collection
      get 'request_except_listing_ngdays', on: :collection
    end
    resources :ngevent_weeks, only: [:create] do
      get 'listing_ngweeks', on: :collection
      put 'unset', on: :collection
    end
    resources :calendar
  end
  
  resources :spots

  resources :favorites, only: [:create, :destroy] do
    collection do
      get :users
      get :listings
      get :spots
    end
  end
  
  resources :pickups, only: [:show]
  resources :friends, only: [:index, :destroy] do
    member do
      post 'send_request'
      post 'accept'
      post 'reject'
    end
    collection do
      get 'list_search'
      get 'search'
      get 'search_friends'
      post 'set_selected_guides'
    end
  end

  resources :reservations, only: [:create, :update] do
    resource :reviews, only: [:create] do
      collection do
        get 'for_guest'
        get 'for_guide'
        post 'create_guest'
        post 'create_guide'
      end
    end
    collection do
      get 'confirm_payment'
      get 'cancel_payment'
      get 'set_reservation_by_listing'
      get 'set_reservation_default'
      get 'set_ngday_reservation_by_listing'
      get 'set_ngday_reservation_default'
      get 'exist_ngday_reservation'
    end
    member do
      get 'friends_list' => 'friends#friends_list'
      post 'send_message_to_selected_guides' => 'friends#send_message_to_selected_guides'
    end
  end

  resources :wishlists
  resources :ngevents do
    get 'reservation_ngdays', on: :collection
    get 'request_ngdays', on: :collection
    get 'common_ngdays', on: :collection
    get 'set_ngday_listing', on: :collection
    get 'select_ngdays', on: :collection
  end
  resources :ngevent_weeks do
    get 'except_common_ngweeks', on: :collection
    get 'common_ngweeks', on: :collection
    get 'set_ngweek_listing', on: :collection
    put 'unset', on: :collection
  end
  resources :calendar do
    get 'common_ngdays', on: :collection
  end

  scope "(:locale)", locale: /ja|en/ do
    resources :help_topics do
      get 'for_user',  on: :collection
      get 'for_guide', on: :collection
      get 'search', on: :collection, action: 'search'
      get 'search_result', on: :collection, action: 'search_result'
    end
  end

  devise_for :users, controllers: {
    sessions:            'users/sessions',
    registrations:       'users/registrations',
    passwords:           'users/passwords',
    omniauth_callbacks:  'users/omniauth_callbacks',
    confirmations:       'users/confirmations'
  }

  devise_scope :user do
    get 'users/withdraw' => 'users/registrations#withdraw'
    get 'users/clear_auth_session' => 'users/registrations#clear_auth_session'
    post 'users/create_email' => 'users/registrations#create_email'
    post 'users/before_omniauth' => 'users/registrations#before_omniauth'
  end

  get "weekly_payment_report" => 'admin/payment#payment_weekly_report'
  get "payment_report_index" => 'admin/payment#index'
  root 'welcome#index'
  
  get '*path', controller: 'application', action: 'render_404'
end
