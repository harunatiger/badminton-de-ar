json.array!(@spots) do |spot|
  json.extract! spot, :id
  json.url spot_url(spot, format: :json)
end
