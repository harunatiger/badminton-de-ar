class PairGuideThread < MessageThread
  belongs_to :reservation
  
  validates :reservation_id, presence: true
  
  def self.existed_pair_guide_thread(reservation_id, user_id)
    mt_user = MessageThreadUser.user_joins(user_id).joins(:message_thread).merge(PairGuideThread.where(reservation_id: reservation_id)).first
    mt_user.present? ? PairGuideThread.find(mt_user.message_thread_id) : false
  end
end
