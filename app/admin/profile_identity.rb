ActiveAdmin.register ProfileIdentity do
  
  permit_params :user_id, :profile_id, :image, :caption, :authorized
  
  index do
    column :id
    column :user_id do |obj|
      link_to obj.id, profile_path(obj.profile_id), :target => ["_blank"]
    end
    column :first_name do |obj|
      obj.profile.first_name
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
