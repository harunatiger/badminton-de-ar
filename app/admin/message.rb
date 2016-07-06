ActiveAdmin.register Message do
  preserve_default_filters!
  remove_filter :user
  filter :from_user_id, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}
  filter :to_user_id, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}
  filter :reservation, :as => :select, :collection => Reservation.all.map{|r| [r.id, r.id]}
  filter :message_thread, :as => :select, :collection => MessageThread.all.map{|mt| [mt.id, mt.id]}
  
  index do
    column :id
    column 'From prof ID' do |message|
      profile = Profile.where(user_id: message.from_user_id).first
      link_to profile.id, profile_path(profile.id), target: '_blank' if profile.present?
    end
    column 'To prof ID' do |message|
      profile = Profile.where(user_id: message.to_user_id).first
      link_to profile.id, profile_path(profile.id), target: '_blank' if profile.present?
    end
    column :content
    column :read
    column :read_at
    column :created_at
    column :updated_at
    column :attached_file
    column :attached_extension
    column :attached_name
    column :friends_request
    actions
  end
  
  csv :force_quotes => false do
	  column :id
    column 'From prof ID' do |message|
      profile = Profile.where(user_id: message.from_user_id).first
      profile.id if profile.present?
    end
    column 'To prof ID' do |message|
      profile = Profile.where(user_id: message.to_user_id).first
      profile.id if profile.present?
    end
    column :content
    column :read
    column :read_at
    column :created_at
    column :updated_at
    column :attached_file
    column :attached_extension
    column :attached_name
    column :friends_request
	end
end
