# == Schema Information
#
# Table name: listing_pickups
#
#  id         :integer          not null, primary key
#  listing_id :integer
#  pickup_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_listing_pickups_on_listing_id  (listing_id)
#  index_listing_pickups_on_pickup_id   (pickup_id)
#

class ListingPickup < ActiveRecord::Base
  belongs_to :listing
  belongs_to :pickup
  
end
