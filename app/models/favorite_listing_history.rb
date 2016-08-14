class FavoriteListingHistory < FavoriteHistory
  belongs_to :user, class_name: 'User', foreign_key: 'from_user_id'
  belongs_to :listing
  
  validates :from_user_id, presence: true
  validates :listing_id, presence: true
  
  validates_uniqueness_of :from_user_id, scope: :listing_id
  
  scope :order_by_created_at_desc, -> { order('created_at desc') }
  scope :created_when, -> from, to { where('created_at >= ? AND created_at <= ?', from.in_time_zone('UTC'), to.in_time_zone('UTC')) }
  
  def self.listings_favorites(listings)
    self.where(listing_id: listings.ids)
  end
end
