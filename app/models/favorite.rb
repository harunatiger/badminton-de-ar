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

class Favorite < ActiveRecord::Base
  soft_deletable
  
  belongs_to :user, class_name: 'User', foreign_key: 'from_user_id'
  belongs_to :user, class_name: 'User', foreign_key: 'to_user_id'
  belongs_to :listing
  belongs_to :spot
  
  scope :order_by_created_at_desc, -> { order('created_at desc') }
  scope :order_by_updated_at_desc, -> { order('updated_at desc') }
  scope :created_when, -> from, to { where('created_at >= ? AND created_at <= ?', from.in_time_zone('UTC'), to.in_time_zone('UTC')) }
  
  def favorite_listing?
    self.type == 'FavoriteListing'
  end
  
  def favorite_user?
    self.type == 'FavoriteUser'
  end
  
  def favorite_spot?
    self.type == 'FavoriteSpot'
  end
  
  def target
    if self.favorite_listing?
      return Listing.find(self.listing_id)
    elsif self.favorite_user?
      return User.find(self.to_user_id)
    elsif self.favorite_spot?
      return Spot.find(self.spot_id)
    end
  end
  
  def old
    if self.favorite_listing?
      FavoriteListing.only_soft_destroyed.where(from_user_id: self.from_user_id, listing_id: self.listing_id).first
    elsif self.favorite_user?
      FavoriteUser.only_soft_destroyed.where(from_user_id: self.from_user_id, to_user_id: self.to_user_id).first
    elsif self.favorite_spot?
      FavoriteSpot.only_soft_destroyed.where(from_user_id: self.from_user_id, spot_id: self.spot_id).first
    end
  end
  
  def self.create_or_restore_from_params(params, user)
    favorite = Favorite.new(from_user_id: user.id, type: params['type'])
    
    if favorite.favorite_listing?
      favorite.listing_id = params['target_id']
    elsif favorite.favorite_user?
      favorite.to_user_id = params['target_id']
    elsif favorite.favorite_spot?
      favorite.spot_id = params['target_id']
    end
    
    if favorite_old = favorite.old
      favorite_old.restore
      favorite = favorite_old
    else
      favorite.save
    end
    favorite.target
  end
end
