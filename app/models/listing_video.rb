# == Schema Information
#
# Table name: listing_videos
#
#  id         :integer          not null, primary key
#  listing_id :integer
#  video      :string           default("")
#  order_num  :integer
#  caption    :string           default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_listing_videos_on_listing_id  (listing_id)
#

class ListingVideo < ActiveRecord::Base
  belongs_to :listing
end
