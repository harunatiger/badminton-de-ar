# == Schema Information
#
# Table name: message_threads
#
#  id                :integer          not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  host_id           :integer
#  reply_from_host   :boolean          default(FALSE)
#  first_message     :boolean          default(TRUE)
#  noticemail_sended :boolean          default(FALSE)
#  reservation_id    :integer
#  type              :string(255)
#
# Indexes
#
#  index_message_threads_on_host_id         (host_id)
#  index_message_threads_on_reservation_id  (reservation_id)
#

class GuestThread < MessageThread
  scope :noreply_push_mail, -> { where(noticemail_sended: false, reply_from_host: false, first_message: true) }
end
