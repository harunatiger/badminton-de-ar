ActiveAdmin.register Message do
  preserve_default_filters!
  remove_filter :user
  filter :from_user_id, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}
  filter :to_user_id, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}
  filter :reservation, :as => :select, :collection => Reservation.all.map{|r| [r.id, r.id]}
  filter :message_thread, :as => :select, :collection => MessageThread.all.map{|mt| [mt.id, mt.id]}
end
