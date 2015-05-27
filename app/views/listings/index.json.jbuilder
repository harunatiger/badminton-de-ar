json.array!(@listings) do |listing|
  json.extract! listing, :id, :user_id, :evaluation_count, :ave_total, :ave_accuracy, :ave_communication, :ave_cleanliness, :ave_location, :ave_check_in, :ave_cost_performance, :open, :zipcode, :location, :longitude, :latitude, :delivery_flg, :price, :description, :title, :capacity, :direction
  json.url listing_url(listing, format: :json)
end
