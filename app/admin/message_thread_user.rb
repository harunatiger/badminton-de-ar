ActiveAdmin.register MessageThreadUser do
  preserve_default_filters!
  filter :user, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}
  filter :message_thread, :as => :select, :collection => MessageThread.all.map{|mt| [mt.id, mt.id]}
end
