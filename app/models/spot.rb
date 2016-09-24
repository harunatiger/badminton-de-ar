# == Schema Information
#
# Table name: spots
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
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
#  index_spots_on_user_id    (user_id)
#

class Spot < ActiveRecord::Base
  belongs_to :user
  belongs_to :pickup
  has_one :spot_image
  
  validates :title, presence: true
  validates :one_word, presence: true
  validate :has_spot_image?
  
  scope :order_by_updated_at_desc, -> { order('updated_at desc') }
  
  accepts_nested_attributes_for :spot_image
  
  def has_spot_image?
    errors.add(:base, Settings.spot_image.save.blank) if self.spot_image.blank?
  end
end
