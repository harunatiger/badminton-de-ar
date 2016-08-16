ActiveAdmin.register Review do
  permit_params :total
  after_update do |review|
    review.re_calc_average
  end
  
  preserve_default_filters!
  remove_filter :user
  filter :host_id, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}
  filter :guest_id, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}
  
  index do
    column :id
    column :guest_prof do |review|
      profile = Profile.find_by_user_id(review.guest_id)
      link_to profile.id, profile_path(profile), target: '_blank' if profile.present?
    end
    column :host_prof do |review|
      profile = Profile.find_by_user_id(review.host_id)
      link_to profile.id, profile_path(profile), target: '_blank' if profile.present?
    end
    column :reservation_id
    column :listing_id do |review|
      link_to review.listing_id, listing_path(review.listing_id), target: '_blank' if review.listing_id.present?
    end
    column :total
    column :msg
    column :type
    column :tour_image
    column :created_at
    column :updated_at
    actions
  end
  
  form do |f|
    f.inputs do
      f.input :total,
              :as => :select,
              :collection => [1,2,3,4,5],
              :include_blank => false
    end
    f.actions
  end
  
  csv :force_quotes => false do
    column :id
    column :guest_id
    column :host_id
    column :reservation_id
    column :listing_id
    column :total
    column :msg
    column :type
    column :tour_image
    column :created_at
    column :updated_at
  end
end
