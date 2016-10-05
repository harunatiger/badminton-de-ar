# == Schema Information
#
# Table name: favorites
#
#  id                :integer          not null, primary key
#  from_user_id      :integer          not null
#  to_user_id        :integer
#  listing_id        :integer
#  read_at           :datetime
#  type              :string           not null
#  soft_destroyed_at :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  spot_id           :integer
#
# Indexes
#
#  index_favorites_on_from_user_id       (from_user_id)
#  index_favorites_on_listing_id         (listing_id)
#  index_favorites_on_soft_destroyed_at  (soft_destroyed_at)
#  index_favorites_on_spot_id            (spot_id)
#  index_favorites_on_to_user_id         (to_user_id)
#  index_favorites_on_type               (type)
#

class FavoriteSpot < Favorite
  soft_deletable dependent_associations: [:spot]
  
  belongs_to :user, class_name: 'User', foreign_key: 'from_user_id'
  belongs_to :spot

  validates :from_user_id, presence: true
  validates :spot_id, presence: true
  
  validates_uniqueness_of :from_user_id, scope: :spot_id
end
