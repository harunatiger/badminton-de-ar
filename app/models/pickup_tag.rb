# == Schema Information
#
# Table name: pickup_tags
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PickupTag < ActiveRecord::Base
  has_many :listing_pickup_tags
  has_many :listings, through: :listing_pickup_tags

end
