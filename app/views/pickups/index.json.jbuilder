json.array!(@pickups) do |pickup|
  json.extract! pickup, :id
  json.url pickup_url(pickup, format: :json)
end
