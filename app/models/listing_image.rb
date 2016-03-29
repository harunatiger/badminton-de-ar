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
    [ { title: 'spa_and_relaxation', image: Settings.image.noimage3.url}, { title: 'cultural_sites', image: Settings.image.noimage3.url}, {title: 'food_and_drink', image: Settings.image.noimage3.url}, {title: 'shopping', image: Settings.image.noimage3.url}, { title: 'outdoors', image: Settings.image.noimage3.url}, { title: 'sports', image: Settings.image.noimage3.url},{ title: 'gardens', image: Settings.image.noimage3.url},{ title: 'tourist_hotspots', image: Settings.image.noimage3.url},{ title: 'art', image: Settings.image.noimage3.url},{ title: 'manga_and_anime', image: Settings.image.noimage3.url},{ title: 'onsen', image: Settings.image.noimage3.url},{ title: 'theme_parks',image: Settings.image.noimage3.url},{ title: 'entertaiment',image: Settings.image.noimage3.url},{ title: 'experiences',image: Settings.image.noimage3.url}, { title: 'night_life', image: Settings.image.noimage3.url}]
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
