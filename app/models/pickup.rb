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
#  cover_image_small :string
#  long_name         :string           default("")
#
# Indexes
#
#  index_pickups_on_short_name  (short_name)
#  index_pickups_on_type        (type)
#

class Pickup < ActiveRecord::Base
  has_many :listing_pickups, dependent: :destroy
  has_many :listings, through: :listing_pickups

  validates :short_name, :long_name, :cover_image, :type, presence: true
  validates :order_number, uniqueness: true, :allow_nil => true
  mount_uploader :cover_image, PickupImageUploader
  mount_uploader :cover_image_small, PickupImageUploader

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
end
