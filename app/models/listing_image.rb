# == Schema Information
#
# Table name: listing_images
#
#  id            :integer          not null, primary key
#  listing_id    :integer
#  image         :string           default("")
#  order_num     :integer
#  caption       :string           default("")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  description   :text             default("")
#  category_list :string           default("")
#
# Indexes
#
#  index_listing_images_on_listing_id  (listing_id)
#

class ListingImage < ActiveRecord::Base
  belongs_to :listing

  mount_uploader :image, DefaultImageUploader
  attr_accessor :image_blank_ok

  scope :slideshow_images, -> id { where(listing_id: id) }
  scope :order_asc, -> { order('order_num asc') }
  #scope :cover_image, -> listing_id { where(listing_id: listing_id) }
  scope :records, -> listing_id { where(listing_id: listing_id) }
  scope :image_limit, -> { order('order_num').limit(Settings.listing_images.max_count) }
  
  def self.image_categories
    [ { title: 'spa_and_relaxation', image: Settings.image.noimage.url}, { title: 'cultural_sites', image: Settings.image.noimage.url}, {title: 'food_and_drink', image: Settings.image.noimage.url}, {title: 'shopping', image: Settings.image.noimage.url}, { title: 'outdoors', image: Settings.image.noimage.url}, { title: 'sports', image: Settings.image.noimage.url},{ title: 'gardens', image: Settings.image.noimage.url},{ title: 'tourist_hotspots', image: Settings.image.noimage.url},{ title: 'art', image: Settings.image.noimage.url},{ title: 'manga_and_anime', image: Settings.image.noimage.url},{ title: 'onsen', image: Settings.image.noimage.url},{ title: 'theme_parks',image: Settings.image.noimage.url},{ title: 'entertaiment',image: Settings.image.noimage.url},{ title: 'experiences',image: Settings.image.noimage.url}, { title: 'night_life', image: Settings.image.noimage.url}]
  end
  
  def set_category(category)
    result = ''
    if self.category_list.present?
      category_list = self.category_list.split(",")
      if category_list.include?(category)
        category_list.delete(category)
        result = 'deleted'
      else
        category_list.push(category)
        result = 'added'
      end
    else
      category_list = []
      category_list[0] = category
      result = 'added'
    end
    category_list = category_list.join(",")
    return 'failure' unless self.update(category_list: category_list)
    result
  end
  
  def category_array
    self.category_list.present? ? self.category_list.split(",") : []
  end
  
  def my_category_hash
    result = []
    ListingImage.image_categories.each do |category|
      result.push(category) if self.category_list.include?(category[:title])
    end
    result
  end
end
