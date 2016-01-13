# == Schema Information
#
# Table name: listing_details
#
#  id                    :integer          not null, primary key
#  listing_id            :integer
#  zipcode               :string
#  location              :string           default("")
#  place                 :string           default("")
#  longitude             :decimal(9, 6)    default(0.0)
#  latitude              :decimal(9, 6)    default(0.0)
#  price                 :integer          default(0)
#  time_required         :decimal(9, 6)    default(0.0)
#  max_num_of_people     :integer          default(0)
#  min_num_of_people     :integer          default(0)
#  condition             :text             default("")
#  refund_policy         :text             default("")
#  in_case_of_rain       :text             default("")
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  place_memo            :text             default("")
#  place_longitude       :decimal(9, 6)    default(0.0)
#  place_latitude        :decimal(9, 6)    default(0.0)
#  price_for_support     :integer          default(0)
#  price_for_both_guides :integer          default(0)
#  space_option          :boolean          default(TRUE)
#  car_option            :boolean          default(TRUE)
#  guests_cost           :integer          default(0)
#  included_guests_cost  :text             default("")
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
  has_many :listing_detail_options, dependent: :destroy
  has_many :options, :through => :listing_detail_options, dependent: :destroy
  
  accepts_nested_attributes_for :listing_detail_options
  validates :listing_id, uniqueness: true
  
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
    
  def basic_amount
    total = self.price + self.price_for_support + self.price_for_both_guides
    total + option_amount
  end
    
  def amount
    basic_amount < 2000 ? (basic_amount + 500).ceil : (basic_amount * 1.125).ceil
  end
    
  def guide_price
    self.price + self.price_for_support + self.price_for_both_guides
  end
    
  def option_amount
    total = 0
    if self.space_option
      self.space_options.each do |space_option|
        total += space_option.price
      end
    end
    
    if self.car_option
      self.car_options.each do |car_option|
        total += car_option.price
      end
    end
    total
  end
    
  def service_fee
    basic_amount < 2000 ? 500 : (basic_amount * 0.125).ceil
  end
    
  def set_price
    self.price = 0 if self.price.blank?
    self.price_for_support = 0 if self.price_for_support.blank?
    self.price_for_both_guides = 0 if self.price_for_both_guides.blank?
    self.guests_cost = 0 if self.guests_cost.blank?
    self.listing_detail_options.each do |listing_detail_option|
      listing_detail_option.price = 0 if listing_detail_option.price.blank?
    end
    self
  end
    
  def space_options
    options = []
    Space.all.each do |option|
      if self.listing_detail_options.where(option_id: option.id).first.blank?
        options << ListingDetailOption.new(option_id: option.id)
      else
        options << self.listing_detail_options.where(option_id: option.id).first
      end
    end
    options
  end
    
  def car_options
    options = []
    Car.all.each do |option|
      if self.listing_detail_options.where(option_id: option.id).first.blank?
        options << ListingDetailOption.new(option_id: option.id)
      else
        options << self.listing_detail_options.where(option_id: option.id).first
      end
    end
    options
  end
    
  def selected_options
    options = []
    if self.space_option
      Space.all.each do |option|
        space_option = self.listing_detail_options.where(option_id: option.id).first
        if space_option.present? and space_option.price > 0
          options << space_option
        end
      end
    end
    
    if self.car_option
      Car.all.each do |option|
        car_option = self.listing_detail_options.where(option_id: option.id).first
        if car_option.present? and car_option.price > 0
          options << car_option
        end
      end
    end
    
    options
  end
end
