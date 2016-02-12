ActiveAdmin.register ProfileBank do
  permit_params :user_id, :profile_id, :name, :branch_name, :account_type, :user_name, :number, :paypal_account
  preserve_default_filters!
  filter :user, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}
end