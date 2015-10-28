# == Schema Information
#
# Table name: listing_pickup_categories
#
#  id                 :integer          not null, primary key
#  listing_id         :integer
#  pickup_category_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_listing_pickup_categories_on_listing_id          (listing_id)
#  index_listing_pickup_categories_on_pickup_category_id  (pickup_category_id)
#

class ListingPickupCategory < ActiveRecord::Base
  belongs_to :listing
  belongs_to :pickup_category

end
