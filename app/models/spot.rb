# == Schema Information
#
# Table name: spots
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  one_word   :string           default("")
#  pickup_id  :integer
#  location   :string           default("")
#  longitude  :decimal(9, 6)
#  latitude   :decimal(9, 6)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_spots_on_pickup_id  (pickup_id)
#

class Spot < ActiveRecord::Base
  has_one :spot_image
  
  validates :title, presence: true
  validates :one_word, presence: true
  validate :has_spot_image?
  
  accepts_nested_attributes_for :spot_image
  
  def has_spot_image?
    errors.add(:base, Settings.spot_image.save.blank) if self.spot_image.blank?
  end
end
