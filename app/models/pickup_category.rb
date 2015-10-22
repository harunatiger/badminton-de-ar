# == Schema Information
#
# Table name: pickup_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PickupCategory < ActiveRecord::Base
  has_many :listing_pickup_categories
  has_many :listings, through: :listing_pickup_categories

end
