class ReviewForGuide < Review
  validates :reservation_id, uniqueness: true
end
