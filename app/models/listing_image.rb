# == Schema Information
#
# Table name: listing_images
#
#  id          :integer          not null, primary key
#  listing_id  :integer
#  image       :string           default("")
#  order_num   :integer
#  caption     :string           default("")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text             default("")
#  category    :string           default("")
#
# Indexes
#
#  index_listing_images_on_listing_id  (listing_id)
#

class ListingImage < ActiveRecord::Base
  belongs_to :listing

  mount_uploader :image, DefaultImageUploader
  attr_accessor :image_blank_ok
  
  validates :caption, length: { maximum: 100, length:100}

  scope :slideshow_images, -> id { where(listing_id: id) }
  scope :order_asc, -> { order('order_num asc') }
  #scope :cover_image, -> listing_id { where(listing_id: listing_id) }
  scope :records, -> listing_id { where(listing_id: listing_id) }
  scope :image_limit, -> { order('order_num').limit(Settings.listing_images.max_count) }
  
  def self.image_categories
    path = 'image_category/'
    [ { title: 'spa_and_relaxation', image: path + 'spa_and_relaxation.png'}, { title: 'cultural_sites', image: path + 'cultual_sites.png'}, {title: 'food_and_drink', image: path + 'food_and_drink.png'}, {title: 'shopping', image: path + 'shopping.png'}, { title: 'outdoors', image: path + 'outdoors.png'}, { title: 'sports', image: path + 'sports.png'},{ title: 'gardens', image: path + 'gardens.png'},{ title: 'tourist_hotspots', image: path + 'tourist_hotspots.png'},{ title: 'art', image: path + 'art.png'},{ title: 'manga_and_anime', image: path + 'manga_and_anime.png'},{ title: 'onsen', image: path + 'onsen.png'},{ title: 'theme_parks',image: path + 'Theme_parks.png'},{ title: 'entertainment',image: path + 'entertainment.png'},{ title: 'experiences',image: path + 'experiences.png'}, { title: 'night_life', image: path + 'night_life.png'}]
  end
  
  def category_image
    result = ''
    ListingImage.image_categories.each do |category|
      if self.category == category[:title]
        result = category 
        break
      end
    end
    result.present? ? result[:image] : ''
  end
  
  def self.distance(new_category, old_category)
    new_coutn = 0
    old_count = 0
    ListingImage.image_categories.each_with_index do |category, i|
      if new_category == category[:title]
        new_coutn = i
      end
      if old_category == category[:title]
        old_count = i
      end
    end
    old_count - new_coutn
  end
end
