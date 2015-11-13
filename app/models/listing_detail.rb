# == Schema Information
#
# Table name: listing_details
#
#  id                      :integer          not null, primary key
#  listing_id              :integer
#  zipcode                 :string
#  location                :string           default("")
#  place                   :string           default("")
#  longitude               :decimal(9, 6)    default(0.0)
#  latitude                :decimal(9, 6)    default(0.0)
#  price                   :integer          default(0)
#  option_price            :integer          default(0)
#  time_required           :decimal(9, 6)    default(0.0)
#  max_num_of_people       :integer          default(0)
#  min_num_of_people       :integer          default(0)
#  included                :text             default("")
#  condition               :text             default("")
#  refund_policy           :text             default("")
#  in_case_of_rain         :text             default("")
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  option_price_per_person :integer          default(0)
#  place_memo              :string           default("")
#  place_longitude         :decimal(9, 6)    default(0.0)
#  place_latitude          :decimal(9, 6)    default(0.0)
#
# Indexes
#
#  index_listing_details_on_latitude    (latitude)
#  index_listing_details_on_listing_id  (listing_id)
#  index_listing_details_on_location    (location)
#  index_listing_details_on_longitude   (longitude)
#  index_listing_details_on_price       (price)
#  index_listing_details_on_zipcode     (zipcode)
#

class ListingDetail < ActiveRecord::Base
  belongs_to :listing
  before_save :set_price
  
  def set_lon_lat
    hash = Hash.new
    if self.location.present?
      hash = self.geocode_with_google_map_api
    end
    if hash['success'].present?
      self.longitude = hash['lng']
      self.latitude = hash['lat']
      self
    else
      self.longitude = 0.0
      self.latitude = 0.0
      self
    end
  end

  def geocode_with_google_map_api
    base_url = "http://maps.google.com/maps/api/geocode/json"
    address = URI.encode(self.location)
    hash = Hash.new
    reqUrl = "#{base_url}?address=#{address}&sensor=false&language=ja"
    response = Net::HTTP.get_response(URI.parse(reqUrl))
    case response
    when Net::HTTPSuccess then
      data = JSON.parse(response.body)
      hash['lat'] = data['results'][0]['geometry']['location']['lat']
      hash['lng'] = data['results'][0]['geometry']['location']['lng']
      hash['success'] = true
    else
      hash['lat'] = 0.00
      hash['lng'] = 0.00
      hash['success'] = false
    end
    hash
  end
    
  def amount
    self.price + self.option_price + self.option_price_per_person
  end
    
  def set_price
    self.price = 0 if self.price.blank?
    self.option_price = 0 if self.option_price.blank?
    self.option_price_per_person = 0 if self.option_price_per_person.blank?
    self
  end
end
