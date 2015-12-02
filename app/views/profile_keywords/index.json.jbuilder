json.array!(@profile_keywords) do |profile_keyword|
  json.extract! profile_keyword, :id
  json.url profile_keyword_url(profile_keyword, format: :json)
end
