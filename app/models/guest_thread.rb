class GuestThread < MessageThread
  scope :noreply_push_mail, -> { where(noticemail_sended: false, reply_from_host: false, first_message: true) }
end