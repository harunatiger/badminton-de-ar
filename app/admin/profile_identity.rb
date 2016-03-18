ActiveAdmin.register ProfileIdentity do

  permit_params :user_id, :profile_id, :image, :caption, :authorized
  preserve_default_filters!
  filter :user, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}

  index do
    column :id
    column :user_id do |obj|
      link_to obj.id, profile_path(obj.profile_id), :target => ["_blank"]
    end
    column :first_name do |obj|
      Profile.find(obj.profile_id).first_name
    end
    column :image
    column :authorized
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :user_id
      row :profile_id
      row :image do |obj|
        link_to image_tag(obj.image.url(:thumb)), obj.image.url, :target => ["_blank"]
      end
      row :caption
      row :authorized
    end
    active_admin_comments
  end

  controller do
    def update
      identity = params[:profile_identity]
      super do |format|
        if identity.present?
          @profile_identity = ProfileIdentity.find_by(user_id: identity[:user_id].to_i)
          if @profile_identity.present?
            ProfileIdentityMailer.send_id_authentication_complete_notification_to_user(@profile_identity).deliver_now! if identity[:authorized].to_i == 1
          end
        end
      end
    end
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
