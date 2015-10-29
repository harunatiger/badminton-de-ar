# == Schema Information
#
# Table name: pickups
#
#  id               :integer          not null, primary key
#  name             :string           default("")
#  cover_image      :string           default("")
#  selected_listing :integer
#  type             :string
#  order_number     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_pickups_on_name  (name)
#  index_pickups_on_type  (type)
#

class PickupArea < Pickup
  mount_uploader :cover_image, PickupImageUploader
end
