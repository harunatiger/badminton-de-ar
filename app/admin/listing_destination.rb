ActiveAdmin.register ListingDestination do
  index do
    ListingDestination.column_names.each do |col|
      column col
    end
    actions
  end
end
