ActiveAdmin.register Pickup do

  permit_params :id, :short_name, :long_name, :cover_image, :cover_image_small, :selected_listing, :type, :icon, :icon_small

  index do
    column 'ID', :id
    column 'ShortName', :short_name
    column 'LongName', :long_name
    column 'CoverImage', :cover_image
    column 'CoverImageSmall', :cover_image_small
    column 'Icon', :icon
    column 'IconSmall', :icon_small
    column 'Listing', :selected_listing
    column 'Type', :type
    actions
  end

  form do |f|
    f.inputs do
      f.input :id, :as => :hidden
      f.input :short_name
      f.input :long_name
      f.input :cover_image
      f.input :cover_image_small
      f.input :icon
      f.input :icon_small
      f.input :selected_listing,
              :label => "Select a Listing:",
              :as => :select,
              :collection =>  f.object.listing_list
      f.input :type,
              :as => :select,
              :collection => ['PickupCategory', 'PickupTag', 'PickupArea']
    end
    f.actions
  end

  show do
    attributes_table do
      row 'ID' do
        resource.id
      end
      row 'ShortName' do
        resource.short_name
      end
      row 'LongName' do
        resource.long_name
      end
      row 'CoverImage' do
        resource.cover_image
      end
      row 'CoverImageSmall' do
        resource.cover_image_small
      end
      row 'Icon' do
        resource.icon
      end
      row 'IconSmall' do
        resource.icon_small
      end
      row 'Listing' do
        Listing.where(id: resource.selected_listing).all.pluck(:title).join(',')
      end
      row 'Type' do
        resource.type
      end
    end
  end
end
