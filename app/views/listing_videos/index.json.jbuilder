json.array!(@listing_videos) do |listing_video|
  json.extract! listing_video, :id
  json.url listing_video_url(listing_video, format: :json)
end
