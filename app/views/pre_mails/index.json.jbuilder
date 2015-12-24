json.array!(@pre_mails) do |pre_mail|
  json.extract! pre_mail, :id
  json.url pre_mail_url(pre_mail, format: :json)
end
