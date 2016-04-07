namespace :move_cover_image_to_listing_image do
  desc 'move cover_image to listing_image'
  task do: :environment do
    begin
      ActiveRecord::Base.transaction do
        Listing.without_soft_destroyed.each do |listing|
          if listing.cover_image.present?
            listing_images = listing.listing_images
            listing_images.each do |listing_image|
              listing_image.update!(order_num: listing_image.order_num + 1)
            end
            ListingImage.create!(image_blank_ok: true, listing_id: listing.id, order_num: 1, image: listing.cover_image.file)
            listing.remove_cover_image!
            listing.save!
          end
        end
      end
    rescue ActiveRecord::Rollback
    end
  end
end
