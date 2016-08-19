ActiveAdmin.register Favorite do
  preserve_default_filters!
  #filter :from_user, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}
  #filter :to_user, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}
  
  index do
    column :id
    column :from_user_prof_id do |obj|
      profile = Profile.where(user_id: obj.from_user_id).first
      link_to profile.id, profile_path(profile), target: '_blank' if profile.present?
    end
    column :from_user_type do |obj|
      user = User.find(obj.from_user_id)
      user.user_type
    end
    column :to_user_prof_id do |obj|
      profile = Profile.where(user_id: obj.to_user_id).first
      link_to profile.id, profile_path(profile), target: '_blank' if profile.present?
    end
    column :to_user_type do |obj|
      user = User.find_by_id(obj.to_user_id)
      user.user_type if user.present?
    end
    column :listing do |obj|
      listing_id = obj.listing_id
      link_to listing_id, listing_path(listing_id), target: '_blank' if listing_id.present?
    end
    column :type
    column :read_at
    column :soft_destroyed_at
    column :created_at
    column :updated_at
    actions
  end
end
