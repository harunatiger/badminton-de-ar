# == Schema Information
#
# Table name: listing_destinations
#
#  id         :integer          not null, primary key
#  listing_id :integer          not null
#  location   :string           not null
#  longitude  :decimal(9, 6)
#  latitude   :decimal(9, 6)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_listing_destinations_on_listing_id  (listing_id)
#

class ListingDestination < ActiveRecord::Base
  belongs_to :listing
  
  validates :listing_id, presence: true
  validates :location, presence: true
end
