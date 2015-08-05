class ListingImageCollection < Base
  DEFAULT_ITEM_COUNT = 10
  attr_accessor :listing_images

  def initialize(attributes = {}, listing_id)
    images = ListingImage.where(listing_id: listing_id).limit_10
    super attributes
    unless listing_images.present?
      self.listing_images = images.present? ? images + (DEFAULT_ITEM_COUNT - images.count).times.map { ListingImage.new(listing_id: listing_id) } : DEFAULT_ITEM_COUNT.times.map { ListingImage.new(listing_id: listing_id) } 
    end
  end

  def listing_images_attributes=(attributes)
    self.listing_images = attributes.map do |_, listing_image_attributes|
      ListingImage.new(listing_image_attributes)
    end
  end

  def valid?
    valid_listing_images = target_listing_images.map(&:valid?).all?
    super && valid_listing_images
  end

  def save
    return false unless valid?
    ListingImage.transaction {
      target_listing_images.each_with_index do |target_listing_image, i|
        target_listing_image.order_num = i + 1
        if target_listing_image.id.present?
          listing_image = ListingImage.find(target_listing_image.id)
          listing_image.update_attributes!(image: target_listing_image.image, caption: target_listing_image.caption, description: target_listing_image.description, order_num: target_listing_image.order_num)
        else
          target_listing_image.save!
        end
      end
    }
    true
  end

  def target_listing_images
    self.listing_images.select { |v| v.id.present? or v.image.present? or v.caption.present? or v.description.present?}
  end
end
