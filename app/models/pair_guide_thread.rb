class PairGuideThread < MessageThread
  validates :reservation_id, presence: true
end
