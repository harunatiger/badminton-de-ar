json.array!(@message_threads) do |message_thread|
  json.extract! message_thread, :id, :user_1_id, :user_2_id
  json.url message_thread_url(message_thread, format: :json)
end
