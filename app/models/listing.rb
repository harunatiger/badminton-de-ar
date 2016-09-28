# == Schema Information
#
# Table name: listings
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  review_count            :integer          default(0)
#  ave_total               :float            default(0.0)
#  ave_accuracy            :float            default(0.0)
#  ave_communication       :float            default(0.0)
#  ave_cleanliness         :float            default(0.0)
#  ave_location            :float            default(0.0)
#  ave_check_in            :float            default(0.0)
#  ave_cost_performance    :float            default(0.0)
#  open                    :boolean          default(FALSE)
#  zipcode                 :string
#  location                :string           default("")
#  longitude               :decimal(9, 6)    default(0.0)
#  latitude                :decimal(9, 6)    default(0.0)
#  delivery_flg            :boolean          default(FALSE)
#  price                   :integer          default(0)
#  description             :text             default("")
#  title                   :string           default("")
#  capacity                :integer          default(0)
#  direction               :text             default("")
#  cover_image             :string           default("")
#  cover_image_caption     :string           default("")
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  cover_video             :text             default("")
#  cover_video_description :text             default("")
#  overview                :text             default("")
#  notes                   :text             default("")
#  recommend1              :string           default("")
#  recommend2              :string           default("")
#  recommend3              :string           default("")
#  soft_destroyed_at       :datetime
#  interview1              :string           default("")
#  interview2              :string           default("")
#  interview3              :string           default("")
#
# Indexes
#
#  index_listings_on_capacity   (capacity)
#  index_listings_on_latitude   (latitude)
#  index_listings_on_location   (location)
#  index_listings_on_longitude  (longitude)
#  index_listings_on_price      (price)
#  index_listings_on_title      (title)
#  index_listings_on_user_id    (user_id)
#  index_listings_on_zipcode    (zipcode)
#

class Listing < ActiveRecord::Base
  include Search
  
  before_validation :fix_destination
  
  soft_deletable
  soft_deletable dependent_associations: [:user]
=begin
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  mapping do
    indexes :id, type: 'string', index: 'not_analyzed'
    indexes :spot_name, type: 'string', analyzer: 'kuromoji'
    indexes :address, type: 'string', analyzer: 'kuromoji'
    indexes :location, type: 'geo_point'
  end
=end

  belongs_to :user
  has_many :listing_images, dependent: :destroy
  has_many :listing_videos, dependent: :destroy
  has_one :confection, dependent: :destroy
  has_one :tool, dependent: :destroy
  has_one :dress_code, dependent: :destroy
  has_one :listing_detail, dependent: :destroy
  has_many :reservations
  has_many :reviews
  has_many :listing_categories, dependent: :destroy
  has_many :categories, :through => :listing_categories, dependent: :destroy
  has_many :listing_languages, dependent: :destroy
  has_many :languages, :through => :listing_languages, dependent: :destroy
  has_many :ngevents
  has_many :listing_pickups, dependent: :destroy
  has_many :pickups, :through =>  :listing_pickups
  has_many :favorites, dependent: :destroy
  has_many :listing_destinations, dependent: :destroy

  mount_uploader :cover_image, DefaultImageUploader
  mount_uploader :cover_video, ListingVideoUploader
  attr_accessor :image_blank_ok
  attr_accessor :not_valid_ok

  accepts_nested_attributes_for :listing_detail
  accepts_nested_attributes_for :listing_destinations, allow_destroy: true

  validates :user_id, presence: true
  #validates :location, presence: true
  #validates :longitude, presence: true
  #validates :latitude, presence: true
  #validates :price, presence: true
  validates :title, presence: true
  validates :overview, presence: true
  validates :interview1, :interview2, :interview3, presence: true, unless: :not_valid_ok
  #validates :description, presence: true
  #validates :capacity, presence: true
  validates_each :cover_video do |record, attr, value|
    if value.present? and value.file.size.to_f > UPLOAD_VIDEO_LIMIT_SIZE.megabytes.to_f
      #record.errors.add(attr, "You cannot upload a file greater than #{UPLOAD_VIDEO_LIMIT_SIZE}MB")
      record.errors.add(attr, I18n.t('errors.messages.size_over',size: UPLOAD_VIDEO_LIMIT_SIZE))
    end
  end
  UPLOAD_VIDEO_LIMIT_SIZE = ENV["UPLOAD_VIDEO_LIMIT_SIZE"].to_i.freeze

  scope :mine, -> user_id { where(user_id: user_id) }
  scope :order_by_updated_at_desc, -> { order('updated_at desc') }
  scope :opened, -> { where(open: true) }
  scope :not_opened, -> { where(open: false) }
  scope :search_location, -> location_sel { where(location_sel) }
  scope :search_keywords, -> keywords_sel { where(keywords_sel) }
  scope :available_num_of_guest?, -> num_of_guest { where("capacity >= ?", num_of_guest) }
  scope :available_price_min?, -> price_min { where("price >= ?", price_min) }
  scope :available_price_max?, -> price_max { where("price <= ?", price_max) }
  
  def fix_destination
    self.listing_destinations.each do |listing_destination|
      self.listing_destinations.delete(listing_destination) if listing_destination.location.blank?
    end
  end
  
  def open_reviews_count
    self.reviews.where(type: 'ReviewForGuide', host_id: self.user_id).joins(:reservation).merge(Reservation.review_open?).count
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
      return false
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

  def self.search(search_params)
    if search_params["longitude"].present? && search_params["latitude"].present?
      listings = Listing.opened
      listing_destinations = ListingDestination.where(listing_id: listings.ids).where.not(latitude: nil, longitude: nil)
      array = listing_destinations
      array.each do |listing_destination|
        distance = Search.distance(search_params["longitude"].to_f, search_params["latitude"].to_f, listing_destination.longitude, listing_destination.latitude)
        
        if distance > 10
          listing_destinations.delete(listing_destination)
        end
      end
      Listing.where(id: listing_destinations.pluck(:listing_id))
    end
#     location_sel = location.matches("\%#{search_params["location"]}\%")
#     if search_params['where'] == 'top' || search_params['where'] == 'header'
#       Listing.search_location(location_sel).available_num_of_guest?(search_params['num_of_guest'])
#     elsif search_params['where'] == 'listing_search'
#       # tba: schedule
#       price = search_params['price'].split(',')
#       price_min = price[0].to_i
#       price_max = price[1].to_i
#       keywords = Listing.arel_table['description']
#       keywords_sel = keywords.matches("\%#{search_params["keywords"]}\%")
#       if search_params['wafuku'].present?
#         Listing.search_location(location_sel)
#                .available_num_of_guest?(search_params['num_of_guest'])
#                .available_price_min?(price_min)
#                .available_price_max?(price_max)
#                .joins{ dress_code.outer }.where{ (dress_code.wafuku == search_params['wafuku']) }
#                .search_keywords(keywords_sel)
#       else
#         Listing.search_location(location_sel)
#                .available_num_of_guest?(search_params['num_of_guest'])
#                .available_price_min?(price_min)
#                .available_price_max?(price_max)
#                .search_keywords(keywords_sel)
#       end
  end

  def current_user_bookmarked?(user_id)
    Favorite.exists?(user_id: user_id, listing_id: self.id)
  end

  def left_step_count_and_elements
    cs = self.complete_steps
    return_array = [cs.count, cs]
  end

  def complete_steps
    result = []
    if self.id.nil?
      result << Settings.left_steps.listing
      result << Settings.left_steps.listing_detail
      result << Settings.left_steps.listing_image
    else
      listing = Listing.find(self.id)
      listing_detail = ListingDetail.where(listing_id: self.id).first
      result << Settings.left_steps.listing unless listing.valid?
      result << Settings.left_steps.listing_image unless (self.listing_images.present? or self.cover_video.present?)
      if listing_detail.present?
        result << Settings.left_steps.listing_detail if listing_detail.time_required == 0.0
      else
        result << Settings.left_steps.listing_detail
      end
    end
    result
  end

  def publish
    self.open = true
    self.save
  end

  def unpublish
    self.open = false
    self.not_valid_ok = true
    self.save
  end

  def unpublish_if_no_image
    self.unpublish if self.listing_images.blank? and self.cover_video.blank?
  end
    
  def cover
    self.listing_images.order_asc.first.present? ? self.listing_images.order_asc.first.image : ''
  end

  def dup_all
    listing_copied = self.dup
    listing_copied.remove_cover_video!
    listing_copied.remove_cover_image!
    #listing_copied.image_blank_ok = true
    listing_copied.listing_detail = self.listing_detail.dup if self.listing_detail.present?
    #listing_copied.cover_image = self.cover_image.file
    #listing_copied.cover_video = self.cover_video.file
    #self.listing_images.each do |listing_image|
    #  listing_copied.listing_images.build(image_blank_ok: true, order_num: listing_image.order_num, image: listing_image.image.file)
    #end
    listing_copied.pickup_ids = self.pickups.ids
    listing_copied.open = false
    listing_copied.title = self.title + ' 2'
    listing_copied.not_valid_ok = true
    listing_copied.ave_total = 0
    listing_copied.save ? listing_copied : false
  end

  def delete_children
    self.remove_cover_video!
    self.open = false
    self.not_valid_ok = true
    self.save
    favorite_listings = FavoriteListing.where(listing_id: self.id)
    favorite_listings.destroy_all if favorite_listings.present?
    self.listing_detail.destroy if self.listing_detail.present?
    self.pickups.destroy_all if self.pickups.present?
    self.listing_images.each do |listing_image|
      listing_image.remove_image!
      listing_image.destroy
    end
    self.ngevents.destroy_all if self.ngevents.present?
    ngevent_weeks = NgeventWeek.where(listing_id: self.id)
    ngevent_weeks.destroy_all if ngevent_weeks.present?
  end
    
  def similar_listings
    area_ids = self.pickups.where(type: 'PickupArea').ids
    listing_ids = ListingPickup.select(:listing_id).where(pickup_id: area_ids).map{|v| v.listing_id}
    listings = Listing.where(id: listing_ids).opened.where.not(id: self.id)
    listings.present? ? listings.order("RANDOM()").limit(3) : []
  end

  def self.check_date(listings, search_params)
    listings_array = []
    listings.each do |listing|
      conflict_listing1 = Ngevent.where('mode = ? AND listing_id = ? AND active = ? AND start >= ? AND end_bk <= ?', 1, listing['id'], 1, search_params['start'], search_params['end'])
      conflict_listing2 = Ngevent.where('mode = ? AND listing_id = ? AND active = ? AND start <= ? AND end_bk >= ?', 1, listing['id'], 1, search_params['start'], search_params['start'])
      conflict_listing3 = Ngevent.where('mode = ? AND listing_id = ? AND active = ? AND start <= ? AND end_bk >= ?', 1, listing['id'], 1, search_params['end'], search_params['end'])
      conflict_ngevent1 = Ngevent.where('listing_id = ? AND mode = ? AND active = ? AND start >= ? AND end_bk <= ?', listing['id'], 0, 1, search_params['start'], search_params['end'])
      conflict_ngevent2 = Ngevent.where('listing_id = ? AND mode = ? AND active = ? AND start <= ? AND end_bk >= ?', listing['id'], 0, 1, search_params['start'], search_params['start'])
      conflict_ngevent3 = Ngevent.where('listing_id = ? AND mode = ? AND active = ? AND start <= ? AND end_bk >= ?', listing['id'], 0, 1, search_params['end'], search_params['end'])

      if conflict_listing1.empty? && conflict_listing2.empty? && conflict_listing3.empty? && conflict_ngevent1.empty? && conflict_ngevent2.empty? && conflict_ngevent3.empty?
        listings_array << listing
      end
    end
    listings_array
  end

  def self.check_reservation_date(params)
    conflict_listing1 = Ngevent.where('mode = ? AND listing_id = ? AND active = ? AND start >= ? AND end_bk <= ?', 1, params['listing_id'], 1, params['start'], params['end'])
    conflict_listing2 = Ngevent.where('mode = ? AND listing_id = ? AND active = ? AND start <= ? AND end_bk >= ?', 1, params['listing_id'], 1, params['start'], params['start'])
    conflict_listing3 = Ngevent.where('mode = ? AND listing_id = ? AND active = ? AND start <= ? AND end_bk >= ?', 1, params['listing_id'], 1, params['end'], params['end'])
    conflict_ngevent1 = Ngevent.where('mode = ? AND listing_id = ? AND active = ? AND start >= ? AND end_bk <= ?', 0, params['listing_id'], 1, params['start'], params['end'])
    conflict_ngevent2 = Ngevent.where('mode = ? AND listing_id = ? AND active = ? AND start <= ? AND end_bk >= ?', 0, params['listing_id'], 1, params['start'], params['start'])
    conflict_ngevent3 = Ngevent.where('mode = ? AND listing_id = ? AND active = ? AND start <= ? AND end_bk >= ?', 0, params['listing_id'], 1, params['end'], params['end'])

    if conflict_listing1.empty? && conflict_listing2.empty? && conflict_listing3.empty? && conflict_ngevent1.empty? && conflict_ngevent2.empty? && conflict_ngevent3.empty?
      return true
    else
      return false
    end
  end
    
  def pv_monthly_count(data)
    BrowsingHistory.where(listing_id: self.id).viewed_when(data.day.beginning_of_month, data.day.end_of_month).count
  end
    
  def favorites_monthly_count(data)
    FavoriteListing.where(listing_id: self.id).created_when(data.day.beginning_of_month, data.day.end_of_month).count
  end
    
  def reservations_monthly_count(data)
    self.reservations.finished_before_yesterday.need_to_guide_pay.finished_when(data.day.beginning_of_month, data.day.end_of_month).count
  end
    
  def reservations_daily_count(day)
    count = self.reservations.finished_before_yesterday.finished_when(day, day).need_to_guide_pay.count
    return count == 0 ? nil : count
  end
    
  def sales_monthly_amount(data)
    reservations = self.reservations.finished_before_yesterday.finished_when(data.day.beginning_of_month, data.day.end_of_month).need_to_guide_pay
    return 0 if reservations.blank?
    
    total_sales = 0
    reservations.each do |reservation|
      total_sales += reservation.main_guide_payment
    end
    total_sales
  end
    
  def sales_daily_amount(day)
    reservations = self.reservations.finished_before_yesterday.finished_when(day, day).need_to_guide_pay
    return 0 if reservations.blank?
    
    total_sales = 0
    reservations.each do |reservation|
      total_sales += reservation.main_guide_payment
    end
    total_sales
  end
    
  def pv_whole_count
    BrowsingHistory.where(listing_id: self.id).count
  end
  
  def favorites_whole_count
    FavoriteListing.where(listing_id: self.id).count
  end
    
  def reservations_whole_count
    self.reservations.finished_before_yesterday.need_to_guide_pay.count
  end
    
  def sales_whole_amount
    reservations = self.reservations.finished_before_yesterday.need_to_guide_pay
    return 0 if reservations.blank?
    
    total_sales = 0
    reservations.each do |reservation|
      total_sales += reservation.main_guide_payment
    end
    total_sales
  end
end
