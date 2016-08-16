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
#
# Indexes
#
#  index_favorites_on_from_user_id       (from_user_id)
#  index_favorites_on_listing_id         (listing_id)
#  index_favorites_on_soft_destroyed_at  (soft_destroyed_at)
#  index_favorites_on_to_user_id         (to_user_id)
#  index_favorites_on_type               (type)
#

class Favorite < ActiveRecord::Base
  soft_deletable
  
  scope :order_by_created_at_desc, -> { order('created_at desc') }
  scope :order_by_updated_at_desc, -> { order('updated_at desc') }
  scope :created_when, -> from, to { where('created_at >= ? AND created_at <= ?', from.in_time_zone('UTC'), to.in_time_zone('UTC')) }
  
  def favorite_listing?
    self.type == 'FavoriteListing'
  end
  
  def favorite_user?
    self.type == 'FavoriteUser'
  end
end
