class FavoriteUserHistory < FavoriteHistory
  belongs_to :user, class_name: 'User', foreign_key: 'from_user_id'
  belongs_to :user, class_name: 'User', foreign_key: 'to_user_id'
  
  validates :from_user_id, presence: true
  validates :to_user_id, presence: true
  
  validates_uniqueness_of :from_user_id, scope: :to_user_id
  
  scope :order_by_created_at_desc, -> { order('created_at desc') }
end
