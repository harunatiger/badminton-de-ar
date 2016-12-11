# == Schema Information
#
# Table name: listing_details
#
#  id                          :integer          not null, primary key
#  listing_id                  :integer
#  zipcode                     :string
#  location                    :string           default("")
#  place                       :string           default("")
#  longitude                   :decimal(9, 6)    default(0.0)
#  latitude                    :decimal(9, 6)    default(0.0)
#  price                       :integer          default(0)
#  time_required               :decimal(9, 6)    default(0.0)
#  max_num_of_people           :integer          default(0)
#  min_num_of_people           :integer          default(0)
#  condition                   :text             default("")
#  refund_policy               :text             default("")
#  in_case_of_rain             :text             default("")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  place_memo                  :text             default("")
#  place_longitude             :decimal(9, 6)    default(0.0)
#  place_latitude              :decimal(9, 6)    default(0.0)
#  price_for_support           :integer          default(0)
#  price_for_both_guides       :integer          default(0)
#  space_option                :boolean          default(TRUE)
#  space_rental                :integer          default(0)
#  car_option                  :boolean          default(TRUE)
#  car_rental                  :integer          default(0)
#  gas                         :integer          default(0)
#  highway                     :integer          default(0)
#  parking                     :integer          default(0)
#  guests_cost                 :integer          default(0)
#  included_guests_cost        :text             default("")
#  stop_if_rain                :boolean          default(FALSE)
#  bicycle_option              :boolean          default(FALSE)
#  bicycle_rental              :integer          default(0)
#  other_option                :boolean          default(FALSE)
#  other_cost                  :integer          default(0)
#  register_detail             :boolean          default(FALSE)
#  transportation_cost_main    :integer          default(0)
#  transportation_cost_support :integer          default(0)
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
  has_many :listing_detail_extra_costs
  
  before_save :set_price
  before_create :set_default_price

  validates :listing_id, uniqueness: true
  validate :check_extra_cost
  #validates :time_required, numericality: {greater_than: 0.0}, on: :update, if: 'register_detail?'
  
  accepts_nested_attributes_for :listing_detail_extra_costs
  
  scope :available_num_of_people, -> num_of_people { where('min_num_of_people <= ? and ? <= max_num_of_people', num_of_people, num_of_people) }
  scope :available_time_required, -> duration_min, duration_max { where('? <= time_required and time_required <= ?', duration_min, duration_max) } 

  def check_extra_cost
    self.listing_detail_extra_costs.each do |extra_cost|
      if extra_cost.description.blank? && (extra_cost.price.blank? || extra_cost.price == 0) && extra_cost.for_each.blank?
        self.listing_detail_extra_costs.delete(extra_cost)
      elsif extra_cost.description.blank? || extra_cost.price.blank? || extra_cost.for_each.blank?
        errors.add(:base, Settings.listing_detail_extra_costs.save.blank)
      end
    end
  end
  
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
    
  def display_amount
    total = self.basic_amount
    if self.max_num_of_people > 1
      if self.bicycle_option
        total += self.bicycle_rental
      end
    end
    total
  end
    
  def bicycle_option_for_a_person
    self.bicycle_option ? self.bicycle_rental : 0
  end

  def basic_amount
    #total = self.price + self.price_for_support + self.price_for_both_guides
    total = self.price + self.price_for_support + self.transportation_cost_main + self.transportation_cost_support
    total + option_amount
  end

  def amount
    #basic_amount < 2000 ? (basic_amount + 500).ceil : (basic_amount * 1.145).ceil
    (basic_amount * 1.145).ceil
  end

  def guide_price
    #self.price + self.price_for_support + self.price_for_both_guides
    self.price + self.price_for_support
  end

  def option_amount
    total = 0
    self.listing_detail_extra_costs.each do |listing_detail_extra_cost|
      if listing_detail_extra_cost.person?
        total += listing_detail_extra_cost.price * self.min_num_of_people
      else
        total += listing_detail_extra_cost.price
      end
    end
    total
  end

  def service_fee
    #basic_amount < 2000 ? 500 : (basic_amount * 0.145).ceil
    Settings.reservation.service_fee
  end

  def set_price
    self.price = 0 if self.price.blank?
    self.price_for_support = 0 if self.price_for_support.blank?
    self.price_for_both_guides = 0 if self.price_for_both_guides.blank?
    self.transportation_cost_main = 0 if self.transportation_cost_main.blank?
    self.transportation_cost_support = 0 if self.transportation_cost_support.blank?

    self.guests_cost = 0 if self.guests_cost.blank?
    self.listing_detail_extra_costs.each do |listing_detail_extra_cost|
      listing_detail_extra_cost.price = 0 if listing_detail_extra_cost.price.blank?
    end
    self
  end
  
  def set_default_price
    self.price = self.recommended_main_price
    self.price_for_support = self.recommended_support_price
  end

  def space_options
    ['space_rental']
  end

  def car_options
    ['car_rental', 'gas', 'highway', 'parking']
  end

  def bicycle_options
    ['bicycle_rental']
  end

  def other_options
    ['other_cost']
  end
  
  #---------listing_detail manage page---------------
  def total_group_extra_cost
    self.listing_detail_extra_costs.team.sum(:price)
  end
  
  def total_person_extra_cost
    self.listing_detail_extra_costs.person.sum(:price)
  end
  
  def payment_amount_main
    self.price + self.transportation_cost_main + self.option_amount - self.service_fee
  end
  
  def payment_amount_support
    self.price_for_support + self.transportation_cost_support - self.service_fee
  end
  
  def recommended_main_price
    (self.time_required * 1500).floor
  end
  
  def recommended_support_price
    (self.time_required * 500).floor
  end
  #--------------------------------------------------
end
