ActiveAdmin.register Auth do
  preserve_default_filters!
  filter :user, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}

end
