ActiveAdmin.register MessageThread do
  preserve_default_filters!
  filter :users, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}
  
  index do
    column :id
    column :user1_prof do |message_thread|
      if !message_thread.guest_thread?
        user1_id = MessageThreadUser.where(message_thread_id: message_thread.id).order_by_created_at_asc.first.try('user_id')
        profile = Profile.find_by_user_id(user1_id)
        link_to profile.id, profile_path(profile), target: '_blank' if profile.present?
      end
    end
    column :user2_prof do |message_thread|
      if !message_thread.guest_thread?
        user2_id = MessageThreadUser.where(message_thread_id: message_thread.id).order_by_created_at_asc.second.try('user_id')
        profile = Profile.find_by_user_id(user2_id)
        link_to profile.id, profile_path(profile), target: '_blank' if profile.present?
      end
    end
    column :guest_prof do |message_thread|
      if message_thread.guest_thread?
        guest_id = message_thread.counterpart_user(message_thread.host_id)
        profile = Profile.find_by_user_id(guest_id)
        link_to profile.id, profile_path(profile), target: '_blank' if profile.present?
      end
    end
    column :host_prof do |message_thread|
      if message_thread.guest_thread?
        profile = Profile.find_by_user_id(message_thread.host_id)
        link_to profile.id, profile_path(profile), target: '_blank' if profile.present?
      end
    end
    column :reply_from_host
    column :first_message
    column :noticemail_sended
    column :type
    column :created_at
    column :updated_at
    actions
  end
  
  csv :force_quotes => false do
    column :id
    column :user1_prof do |message_thread|
      if !message_thread.guest_thread?
        user1_id = MessageThreadUser.where(message_thread_id: message_thread.id).order_by_created_at_asc.first.try('user_id')
        profile = Profile.find_by_user_id(user1_id)
        profile.id if profile.present?
      end
    end
    column :user2_prof do |message_thread|
      if !message_thread.guest_thread?
        user2_id = MessageThreadUser.where(message_thread_id: message_thread.id).order_by_created_at_asc.second.try('user_id')
        profile = Profile.find_by_user_id(user2_id)
        profile.id if profile.present?
      end
    end
    column :guest_prof do |message_thread|
      if message_thread.guest_thread?
        guest_id = message_thread.counterpart_user(message_thread.host_id)
        profile = Profile.find_by_user_id(guest_id)
        profile.id if profile.present?
      end
    end
    column :host_prof do |message_thread|
      if message_thread.guest_thread?
        profile = Profile.find_by_user_id(message_thread.host_id)
        profile.id if profile.present?
      end
    end
    column :reply_from_host
    column :first_message
    column :noticemail_sended
    column :type
    column :created_at
    column :updated_at
  end
end
