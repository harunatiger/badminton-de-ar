ActiveAdmin.register Listing do
  permit_params :user_id, :ave_total, :ave_accuracy, :ave_communication, :ave_cleanliness, :ave_location, :ave_check_in, :ave_cost_performance, :open, :zipcode, :location, :longitude, :latitude, :delivery_flg, :price, :description, :title, :capacity, :direction, :cover_image_caption, :cover_video_description, :admin_closed_at
  
  preserve_default_filters!
  filter :user, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}
  filter :reservations, :as => :select, :collection => Reservation.all.map{|r| [r.id, r.id]}
  
  index do
    Listing.column_names.each do |col|
      if col == 'user_id'
        column col
        column 'profile_id' do |listing|
          profile = Profile.find_by_user_id(listing.user_id)
          link_to profile.id, profile_path(profile.id), target: '_blank' if profile.present?
        end
      else
        column col
      end
    end
    actions defaults: true do |listing|
      item 'create destination', new_admin_listing_destination_path(:listing_destination => { :listing_id => listing.id }), class: 'view_link member_link'
      if listing.admin_closed_at.blank?
        item 'Close', close_admin_listing_path(listing), method: :PATCH, class: 'view_link member_link', data: {confirm: 'このツアーを非公開にします。よろしいですか？'}
      else
        item 'Open', open_admin_listing_path(listing), method: :PATCH, class: 'view_link member_link', data: {confirm: 'このツアーを公開します。よろしいですか？'}
      end
    end
  end
  
  csv :force_quotes => false do
    Listing.column_names.each do |col|
      if col == 'user_id'
        column col
        column 'profile_id' do |listing|
          profile = Profile.find_by_user_id(listing.user_id)
          profile.id if profile.present?
        end
      else
        column col
      end
    end
  end
  
  member_action :close, method: :patch do
    listing = Listing.find_by_id(params[:id])
    listing.update(admin_closed_at: Time.zone.now, open: false)
    redirect_to admin_listings_path
  end
  
  member_action :open, method: :patch do
    listing = Listing.find_by_id(params[:id])
    listing.update(admin_closed_at: nil, open: true)
    redirect_to admin_listings_path
  end
end
