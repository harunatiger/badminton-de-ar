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

class PairGuideThread < MessageThread
  belongs_to :reservation
  
  validates :reservation_id, presence: true
  
  def self.existed_pair_guide_thread(reservation_id, user_id)
    mt_user = MessageThreadUser.user_joins(user_id).joins(:message_thread).merge(PairGuideThread.where(reservation_id: reservation_id)).first
    mt_user.present? ? PairGuideThread.find(mt_user.message_thread_id) : false
  end
end
