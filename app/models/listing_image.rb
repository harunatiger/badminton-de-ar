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
    [ { title: 'spa_and_relaxation', image: path + 'spa_icon_01.png'}, { title: 'cultural_sites', image: path + 'culturalsites_icon_01.png'}, {title: 'food_and_drink', image: path + 'food_icon_01.png'}, {title: 'shopping', image: path + 'shopping_icon_01.png'}, { title: 'outdoors', image: path + 'outdoor_icon_01.png'}, { title: 'sports', image: path + 'sports_icon_01.png'},{ title: 'gardens', image: path + 'garden_icon_01.png'},{ title: 'tourist_hotspots', image: path + 'hotspots_icon_01.png'},{ title: 'art', image: path + 'art_icon_01.png'},{ title: 'manga_and_anime', image: path + 'anime_icon_01.png'},{ title: 'onsen', image: path + 'onsen_icon_01.png'},{ title: 'theme_parks',image: path + 'themepark_icon_01.png'},{ title: 'entertainment',image: path + 'entertainment_icon_01.png'},{ title: 'experiences',image: path + 'experience_icon_01.png'}, { title: 'night_life', image: path + 'nightlife_icon_01.png'}]
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
  
  def category_image_thumb
    result = ''
    ListingImage.image_categories.each do |category|
      if self.category == category[:title]
        result = category 
        break
      end
    end
    result.present? ? result[:image].gsub('01', '02') : ''
  end
  
  def category_hash
    result = ''
    ListingImage.image_categories.each do |category|
      if self.category == category[:title]
        result = category 
        result[:image] = result[:image].gsub('01', '02')
        break
      end
    end
    result.present? ? result : ''
  end
  
  def self.distance(new_category, old_category)
    new_coutn = 0
    old_count = 0
    ListingImage.image_categories.each_with_index do |category, i|
      i += 1
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
