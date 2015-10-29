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


  mount_uploader :cover_image, DefaultImageUploader
  mount_uploader :cover_video, ListingVideoUploader

  validates :user_id, presence: true
  #validates :location, presence: true
  #validates :longitude, presence: true
  #validates :latitude, presence: true
  #validates :price, presence: true
  validates :title, presence: true
  #validates :description, presence: true
  #validates :capacity, presence: true
  validates_each :cover_video do |record, attr, value|
    if value.present? and value.file.size.to_f > UPLOAD_VIDEO_LIMIT_SIZE.megabytes.to_f
      record.errors.add(attr, "You cannot upload a file greater than #{UPLOAD_VIDEO_LIMIT_SIZE}MB")
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
    location = Listing.arel_table['location']
    location_sel = location.matches("\%#{search_params["location"]}\%")
    if search_params['where'] == 'top' || search_params['where'] == 'header'
      Listing.search_location(location_sel).available_num_of_guest?(search_params['num_of_guest'])
    elsif search_params['where'] == 'listing_search'
      # tba: schedule
      price = search_params['price'].split(',')
      price_min = price[0].to_i
      price_max = price[1].to_i
      keywords = Listing.arel_table['description']
      keywords_sel = keywords.matches("\%#{search_params["keywords"]}\%")
      if search_params['wafuku'].present?
        Listing.search_location(location_sel)
               .available_num_of_guest?(search_params['num_of_guest'])
               .available_price_min?(price_min)
               .available_price_max?(price_max)
               .joins{ dress_code.outer }.where{ (dress_code.wafuku == search_params['wafuku']) }
               .search_keywords(keywords_sel)
      else
        Listing.search_location(location_sel)
               .available_num_of_guest?(search_params['num_of_guest'])
               .available_price_min?(price_min)
               .available_price_max?(price_max)
               .search_keywords(keywords_sel)
      end
    end
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
    #result << Settings.left_steps.listing_image unless ListingImage.exists?(listing_id: self.id
    result << Settings.left_steps.listing_image unless (self.listing_images.present? or self.cover_image.present? or self.cover_video.present?)
    result << Settings.left_steps.listing_detail unless ListingDetail.exists?(listing_id: self.id)
    #result << Settings.left_steps.confection unless Confection.exists?(listing_id: self.id)
    #result << Settings.left_steps.tool unless Tool.exists?(listing_id: self.id)
    #result << Settings.left_steps.dress_code unless DressCode.exists?(listing_id: self.id)
    result
  end

  def publish
    self.open = true
    self.save
  end
  
  def unpublish
    self.open = false
    self.save
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
end
