ActiveAdmin.register Pickup do

  permit_params :id, :name, :cover_image, :cover_image_small, :selected_listing, :type, :order_number

  index do
    column 'ID', :id
    column 'Name', :name
    column 'CoverImage', :cover_image
    column 'CoverImageSmall', :cover_image_small
    column 'Listing', :selected_listing
    column 'Type', :type
    column 'OrderNum', :order_number
    actions
  end

  form do |f|
    f.inputs do
      f.input :id, :as => :hidden
      f.input :name
      f.input :cover_image
      f.input :cover_image_small
      f.input :selected_listing,
              :label => "Select a Listing:",
              :as => :select,
              :collection =>  Listing.where(id: ListingPickup.where(pickup_id: f.object.id).select('listing_id')).opened
      f.input :type,
              :as => :select,
              :collection => ['PickupCategory', 'PickupTag', 'PickupArea']
      f.input :order_number,
              :as => :select,
              :collection => [*1..4]
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
      row 'CoverImageSmall' do
        resource.cover_image_small
      end
      row 'Listing' do
        Listing.where(id: resource.selected_listing).all.pluck(:title).join(',')
      end
      row 'Type' do
        resource.type
      end
      row 'OrderNumber' do
        resource.order_number
      end
    end
  end


end
