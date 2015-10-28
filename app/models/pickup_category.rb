# == Schema Information
#
# Table name: pickup_categories
#
#  id               :integer          not null, primary key
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  cover_image      :string
#  selected_listing :integer
#

class PickupCategory < ActiveRecord::Base
  belongs_to :listing
  has_many :listing_pickup_categories
  has_many :listings, through: :listing_pickup_categories

  mount_uploader :cover_image, DefaultImageUploader

end
