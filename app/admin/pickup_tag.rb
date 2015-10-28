ActiveAdmin.register PickupTag do

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
  permit_params :id, :name, :cover_image, :selected_listing

  index do
    column 'ID', :id
    column 'Name', :name
    column 'CoverImage', :cover_image
    column 'listing' do |pickup_tag|
      Listing.where(id: pickup_tag.selected_listing).all.pluck(:title).join(',')
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :id, :as => :hidden
      f.input :name
      f.input :cover_image
      f.input :selected_listing,
              :label => "Select a Listing:",
              :as => :select,
              :collection =>  Listing.where(id: ListingPickupTag.where(pickup_tag_id: f.object.id).select('listing_id')).opened
    end
    f.actions
  end

  show do
    attributes_table do
      row 'ID' do
        resource.id
      end
      row 'Name' do
        resource.name
      end
      row 'CoverImage' do
        resource.cover_image
      end
      row 'Listing' do
        Listing.where(id: resource.selected_listing).all.pluck(:title).join(',')
      end
    end
  end

end
