json.array!(@listing_destinations) do |listing_destination|
  json.extract! listing_destination, :id
  json.url listing_destination_url(listing_destination, format: :json)
end
