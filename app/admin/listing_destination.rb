ActiveAdmin.register ListingDestination do
  permit_params :listing_id, :location, :latitude, :longitude
  index do
    ListingDestination.column_names.each do |col|
      column col
    end
    actions
  end
  
  form do |f|
    f.inputs do
      f.input :listing_id
      f.input :location
      f.input :latitude
      f.input :longitude
    end
    actions
  end
  
  csv :force_quotes => false do
    ListingDestination.column_names.each do |col|
      column col
    end
  end
end
