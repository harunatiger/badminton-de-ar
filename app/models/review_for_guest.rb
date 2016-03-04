class ReviewForGuest < Review
  validates :reservation_id, uniqueness: true
end
