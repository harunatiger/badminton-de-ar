json.array!(@auths) do |auth|
  json.extract! auth, :id, :user_id, :provider, :uid, :token
  json.url auth_url(auth, format: :json)
end
