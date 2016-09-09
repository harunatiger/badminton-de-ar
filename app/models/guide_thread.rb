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

class GuideThread < MessageThread
  def self.exists_thread_for_pair_request?(to_user_id, from_user_id)
    t_threads = User.find(to_user_id).message_threads.typed(self.model_name.name)
    f_threads = User.find(from_user_id).message_threads.typed(self.model_name.name)
    
    result = t_threads & f_threads
    if result.size.zero?
      res = false
    else
      res = result[0]
      #result.each do |mt|
      #  if mt.main_guide_id == from_user_id
      #    res = mt
      #    break
      #  end
      #end
    end
    res
  end
  
  def main_guide
    User.find(self.main_guide_id)
  end
end
