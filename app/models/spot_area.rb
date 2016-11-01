# == Schema Information
#
# Table name: spot_areas
#
#  id         :integer          not null, primary key
#  spot_id    :integer
#  pickup_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_spot_areas_on_pickup_id  (pickup_id)
#  index_spot_areas_on_spot_id    (spot_id)
#

class SpotArea < ActiveRecord::Base
  belongs_to :spot
  belongs_to :pickup
end
