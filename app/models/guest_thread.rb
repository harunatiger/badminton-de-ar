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
#  type              :string
#  reservation_id    :integer
#
# Indexes
#
#  index_message_threads_on_host_id         (host_id)
#  index_message_threads_on_reservation_id  (reservation_id)
#

class GuestThread < MessageThread
  scope :noreply_push_mail, -> { where(noticemail_sended: false, reply_from_host: false, first_message: true) }
  
  def self.get_message_thread_id(to_user_id, from_user_id)
    to_user_id = to_user_id.to_i
    from_user_id = from_user_id.to_i
    return false if to_user_id == from_user_id
    unless id = GuestThread.exists_thread?(to_user_id, from_user_id)
      id = GuestThread.create_thread(to_user_id, from_user_id).id
    end
    id
  end
end
