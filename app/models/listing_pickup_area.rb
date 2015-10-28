# == Schema Information
#
# Table name: listing_pickup_areas
#
#  id             :integer          not null, primary key
#  listing_id     :integer
#  pickup_area_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_listing_pickup_areas_on_listing_id      (listing_id)
#  index_listing_pickup_areas_on_pickup_area_id  (pickup_area_id)
#

class ListingPickupArea < ActiveRecord::Base
  belongs_to :listing
  belongs_to :pickup_area

end
