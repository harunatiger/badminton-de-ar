# == Schema Information
#
# Table name: tools
#
#  id         :integer          not null, primary key
#  listing_id :integer
#  name       :string           not null
#  url        :string           default("")
#  image      :string           default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tools_on_listing_id           (listing_id)
#  index_tools_on_listing_id_and_name  (listing_id,name) UNIQUE
#

class Tool < ActiveRecord::Base
  belongs_to :listing

  validates :listing_id, presence: true
  validates :name, presence: true

  mount_uploader :image, DefaultImageUploader

  scope :mine, -> listing_id { where(listing_id: listing_id) }
  scope :order_asc, -> { order('order_num asc') }
  scope :records, -> listing_id { where(listing_id: listing_id) }
end
