# == Schema Information
#
# Table name: pickup_areas
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cover_image :string
#

class PickupArea < ActiveRecord::Base
  has_many :listing_pickup_areas
  has_many :listings, through: :listing_pickup_areas

end
