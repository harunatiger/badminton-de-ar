# == Schema Information
#
# Table name: listing_pickup_tags
#
#  id            :integer          not null, primary key
#  listing_id    :integer
#  pickup_tag_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_listing_pickup_tags_on_listing_id     (listing_id)
#  index_listing_pickup_tags_on_pickup_tag_id  (pickup_tag_id)
#

class ListingPickupTag < ActiveRecord::Base
  belongs_to :listing
  belongs_to :pickup_tag

end
