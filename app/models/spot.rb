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
  scope :mine, -> user_id { where(user_id: user_id) }
  
  accepts_nested_attributes_for :spot_image
  
  def has_spot_image?
    errors.add(:base, Settings.spot_image.save.blank) if self.spot_image.blank?
  end
  
  def near_spots
    list = []
    if self.longitude.present? && self.latitude.present?
      Spot.where.not(id: self.id).order_by_updated_at_desc.each do |spot|
        if spot.longitude.present? && spot.latitude.present?
          from_x = self.longitude * Math::PI / 180
          from_y = self.latitude * Math::PI / 180
          to_x = spot.longitude * Math::PI / 180
          to_y = spot.latitude * Math::PI / 180
          earth_r = 6378140

          deg = Math::sin(from_y) * Math::sin(to_y) + Math::cos(from_y) * Math::cos(to_y) * Math::cos(to_x - from_x)
          distance = earth_r * (Math::atan(-deg / Math::sqrt(-deg * deg + 1)) + Math::PI / 2) / 1000

          if distance < 10
            list.push(spot)
          end
        end
      end
      return list.sample(3)
    else
      return nil
    end
  end
end
