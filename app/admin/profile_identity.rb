ActiveAdmin.register ProfileIdentity do
  
  permit_params :user_id, :profile_id, :image, :caption, :authorized
  show do
    attributes_table do
      row :id
      row :user_id
      row :profile_id
      row :image do |obj|
        image_tag(obj.image.url(:thumb))
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
