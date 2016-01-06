# == Schema Information
#
# Table name: favorite_listings
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  listing_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_favorite_listings_on_listing_id  (listing_id)
#  index_favorite_listings_on_user_id     (user_id)
#

class FavoriteListing < ActiveRecord::Base
  belongs_to :user
  belongs_to :listing

  validates :user_id, presence: true
  validates :listing_id, presence: true

end
