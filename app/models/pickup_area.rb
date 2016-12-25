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
#  longitude         :decimal(9, 6)
#  latitude          :decimal(9, 6)
#
# Indexes
#
#  index_pickups_on_short_name  (short_name)
#  index_pickups_on_type        (type)
#

class PickupArea < Pickup
  mount_uploader :cover_image, PickupImageUploader
  mount_uploader :cover_image_small, PickupImageUploader
  mount_uploader :icon, PickupImageUploader
  mount_uploader :icon_small, PickupImageUploader
end
