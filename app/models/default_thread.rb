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
#  index_message_threads_on_create_user_id  (create_user_id)
#  index_message_threads_on_host_id         (host_id)
#  index_message_threads_on_reservation_id  (reservation_id)
#

class DefaultThread < MessageThread
  def self.exists_default_thread?(user_id, user_id_2)
    t_threads = User.find(user_id).message_threads.typed(self.model_name.name)
    f_threads = User.find(user_id_2).message_threads.typed(self.model_name.name)
    
    result = t_threads & f_threads
    if result.size.zero?
      return false
    else
      return result[0]
    end
  end
  
  def self.get_message_thread_id(to_user_id, from_user_id)
    return false if to_user_id == from_user_id
    unless id = DefaultThread.exists_default_thread?(to_user_id, from_user_id)
      id = DefaultThread.create_thread(to_user_id, from_user_id).id
    end
    id
  end
  
  def get_guest_thread_id(host_id)
    guest = self.counterpart_user(host_id)
    if message_thread_id = GuestThread.exists_thread?(host_id, guest.id)
      message_thread = GuestThread.find(message_thread_id)
      if message_thread.messages.present?
        message_thread_id = message_thread.id
      else
        message_thread.destroy!
        self.update(type: 'GuestThread', host_id: host_id, reply_from_host: true)
        self.set_reply_from_host
      end
    else
      self.update(type: 'GuestThread', host_id: host_id, reply_from_host: true)
      message_thread_id = self.id
    end
    message_thread_id
  end
end
