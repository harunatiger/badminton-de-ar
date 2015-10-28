json.array!(@listing_details) do |listing_detail|
  json.extract! listing_detail, :id
  json.url listing_detail_url(listing_detail, format: :json)
end
