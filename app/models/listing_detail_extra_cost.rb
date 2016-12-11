# == Schema Information
#
# Table name: listing_detail_extra_costs
#
#  id                :integer          not null, primary key
#  listing_detail_id :integer
#  description       :string
#  price             :integer          default(0)
#  for_each          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_listing_detail_extra_costs_on_listing_detail_id  (listing_detail_id)
#

class ListingDetailExtraCost < ActiveRecord::Base
  belongs_to :listing_detail
  
  # validates :listing_detail_id, presence: true
  # validates :description, presence: true
  # validates :price, presence: true
  # validates :for_each, presence: true
  enum for_each: { team: 0, person: 1}
end
