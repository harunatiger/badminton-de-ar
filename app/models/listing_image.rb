# == Schema Information
#
# Table name: listing_images
#
#  id          :integer          not null, primary key
#  listing_id  :integer
#  image       :string           default("")
#  order_num   :integer
#  caption     :string           default("")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text             default("")
#
# Indexes
#
#  index_listing_images_on_listing_id  (listing_id)
#

class ListingImage < ActiveRecord::Base
  belongs_to :listing

  mount_uploader :image, DefaultImageUploader

  scope :slideshow_images, -> id { where(listing_id: id) }
  scope :order_asc, -> { order('order_num asc') }
  scope :cover_image, -> listing_id { where(listing_id: listing_id) }
  scope :records, -> listing_id { where(listing_id: listing_id) }
  scope :limit_5, -> { order('order_num').limit(5) }
end
