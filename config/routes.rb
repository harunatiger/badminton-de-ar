Rails.application.routes.draw do

  get 'static_pages/cancel_policy_en'
  get 'static_pages/service_agreement_en'
  get 'static_pages/specific_commercial_transactions_en'
  get 'static_pages/privacy_policy_en'
  get 'static_pages/cancel_policy_jp'
  get 'static_pages/service_agreement_jp'
  get 'static_pages/specific_commercial_transactions_jp'
  get 'static_pages/privacy_policy_jp'
  get 'static_pages/about'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :profiles do
    resources :profile_images, only: [:show, :create, :update, :destroy] do
      get 'manage', on: :collection
      put 'change_order', on: :collection
    end
    resources :profile_banks
    resources :profile_identities, only: [:new, :edit, :create, :update, :destroy]
    resources :profile_keywords
    member do
      get 'self_introduction',    action: 'self_introduction'
    end
    member do
      post :favorite_user
    end
  end

  get 'dashboard'                           => 'dashboard#index'
  get 'dashboard/host_reservation_manager'  => 'dashboard#host_reservation_manager'
  get 'dashboard/guest_reservation_manager' => 'dashboard#guest_reservation_manager'
  # get 'reviews'                             => 'profiles#review', as: 'user_review'
  # get 'introductions'                       => 'profiles#introduction', as: 'introduction'
  #get 'pickups/show/:type/:id'                    => 'listing_pickups#show', as: 'pickups_list'

  resources :message_threads, except: [:edit]

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
    member do
      post :favorite_listing
    end
  end

  resources :favorite_listings, only: [:index, :destroy]
  resources :favorite_users, only: [:index, :destroy]
  resources :pickups, only: [:show]

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
      get 'for_user', on: :collection
      get 'for_guide', on: :collection
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
  end

  get "weekly_payment_report" => 'admin/payment#payment_weekly_report'
  get "payment_report_index" => 'admin/payment#index'
  root 'welcome#index'
end
