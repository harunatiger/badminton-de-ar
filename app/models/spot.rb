# == Schema Information
#
# Table name: spots
#
#  id                :integer          not null, primary key
#  user_id           :integer          not null
#  title             :string           not null
#  one_word          :string           default("")
#  pickup_id         :integer
#  location          :string           default("")
#  longitude         :decimal(9, 6)
#  latitude          :decimal(9, 6)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  soft_destroyed_at :datetime
#
# Indexes
#
#  index_spots_on_pickup_id  (pickup_id)
#  index_spots_on_user_id    (user_id)
#

class Spot < ActiveRecord::Base
  include Search
  soft_deletable dependent_associations: [:user]
  
  belongs_to :user
  belongs_to :pickup
  has_many :favorites
  has_one :spot_image
  
  validates :title, presence: true
  validates :one_word, presence: true
  validate :has_spot_image?
  
  scope :order_by_updated_at_desc, -> { order('updated_at desc') }
  scope :order_by_favorite_count_desc, -> { select("spots.*, count(favorites.id) AS favorites_count").
                                joins("LEFT JOIN favorites ON spots.id = favorites.spot_id").
                                group("spots.id").
                                order("favorites_count DESC, spots.updated_at DESC")}
  scope :mine, -> user_id { where(user_id: user_id) }
  
  accepts_nested_attributes_for :spot_image
  
  def has_spot_image?
    errors.add(:base, Settings.spot_image.save.blank) if self.spot_image.blank?
  end
  
  def near_spots
    list = []
    if self.longitude.present? && self.latitude.present?
      Spot.without_soft_destroyed.where.not(id: self.id).order_by_updated_at_desc.each do |spot|
        if spot.longitude.present? && spot.latitude.present?
          distance = Search.distance(self.longitude, self.latitude, spot.longitude, spot.latitude)
          if distance < Settings.search.distance
            list.push(spot)
          end
        end
      end
      return list.sample(3)
    else
      return nil
    end
  end
  
  def self.search(search_params)
    if search_params["longitude"].present? && search_params["latitude"].present?
      if search_params["spot_category"].present?
        spots = Spot.where.without_soft_destroyed.not(latitude: nil, longitude: nil).where(pickup_id: search_params["spot_category"])
      else
        spots = Spot.where.without_soft_destroyed.not(latitude: nil, longitude: nil)
      end
      spot_id_array = []
      spots.each do |spot|
        distance = Search.distance(search_params["longitude"].to_f, search_params["latitude"].to_f, spot.longitude, spot.latitude)
        
        if distance <= Settings.search.distance
          spot_id_array.push(spot.id)
        end
      end
      spots = Spot.where(id: spot_id_array).order_by_favorite_count_desc
    end
  end
end
