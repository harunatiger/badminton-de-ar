json.array!(@messages) do |message|
  json.extract! message, :id, :message_thread_id, :schedule, :number, :content, :progress, :read
  json.url message_url(message, format: :json)
end
