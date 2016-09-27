ActiveAdmin.register Listing do
  permit_params :user_id, :ave_total, :ave_accuracy, :ave_communication, :ave_cleanliness, :ave_location, :ave_check_in, :ave_cost_performance, :open, :zipcode, :location, :longitude, :latitude, :delivery_flg, :price, :description, :title, :capacity, :direction, :cover_image_caption, :cover_video_description
  
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
    actions
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
end
