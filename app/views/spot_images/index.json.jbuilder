json.array!(@spot_images) do |spot_image|
  json.extract! spot_image, :id
  json.url spot_image_url(spot_image, format: :json)
end
