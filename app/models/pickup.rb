# == Schema Information
#
# Table name: pickups
#
#  id                :integer          not null, primary key
#  short_name        :string           default("")
#  cover_image       :string           default("")
#  selected_listing  :integer
#  type              :string
#  order_number      :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  cover_image_small :string           default("")
#  long_name         :string           default("")
#  icon              :string           default("")
#  icon_small        :string           default("")
#
# Indexes
#
#  index_pickups_on_short_name  (short_name)
#  index_pickups_on_type        (type)
#

class Pickup < ActiveRecord::Base
  has_many :listing_pickups, dependent: :destroy
  has_many :listings, through: :listing_pickups
  has_many :spot_areas, dependent: :destroy
  has_many :spots, through: :spot_areas
  has_many :profile_pickups, dependent: :destroy
  has_many :profiles, through: :profile_pickups

  validates :short_name, :long_name, :cover_image, :type, presence: true
  validates :order_number, uniqueness: true, :allow_nil => true
  mount_uploader :cover_image, PickupImageUploader
  mount_uploader :cover_image_small, PickupImageUploader
  mount_uploader :icon, PickupImageUploader
  mount_uploader :icon_small, PickupImageUploader
  
  scope :order_by_created_at_asc, -> { order('created_at asc') }

  def self.pickup_obj_by_order_number(order_number)
    self.where(order_number: order_number).where.not(selected_listing: nil).first
  end

  def self.pickup_arry
    pickups = []
    pickups[0] = Pickup.pickup_obj_by_order_number(2)
    pickups[1] = Pickup.pickup_obj_by_order_number(3)
    pickups[2] = Pickup.pickup_obj_by_order_number(4)
    pickups
  end
  
  def listings_by_listing_images
    Listing.where(id: ListingImage.where.not(pickup_id: nil).where(pickup_id: self.id).select('listing_id')).without_soft_destroyed.opened
  end
  
  def listings
    Listing.where(id: ListingPickup.where(pickup_id: self.id).select('listing_id')).without_soft_destroyed.opened
  end
  
  def benchmark_listings
    Listing.where(id: ListingPickup.where(pickup_id: self.id).select('listing_id')).without_soft_destroyed
  end
  
  def benchmark_listings_by_listing_images
    Listing.where(id: ListingImage.where.not(pickup_id: nil).where(pickup_id: self.id).select('listing_id')).without_soft_destroyed
  end
  
  def listing_list
    return self.listings_by_listing_images if self.listings_by_listing_images.present?
    listings
  end
  
  def pickup_area?
    self.type == 'PickupArea'
  end
  
  def pickup_tag?
    self.type == 'PickupTag'
  end 
end
