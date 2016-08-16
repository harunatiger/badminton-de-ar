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
end
