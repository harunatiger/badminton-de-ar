# == Schema Information
#
# Table name: dress_codes
#
#  id         :integer          not null, primary key
#  listing_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  wafuku     :boolean          default(FALSE)
#  note       :text             default("")
#
# Indexes
#
#  index_dress_codes_on_listing_id  (listing_id)
#

class DressCode < ActiveRecord::Base
  belongs_to :listing

  validates :listing_id, presence: true

  scope :order_asc, -> { order('order_num asc') }
  scope :records, -> listing_id { where(listing_id: listing_id) }
end
