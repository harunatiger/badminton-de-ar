namespace :move_category_data do
  desc 'move category data'
  task do: :environment do
    begin
      ActiveRecord::Base.transaction do
        ProfileCategory.all.each do |profile_category|
          category_id = profile_category.category.name
          category_name = I18n.t('listing_images.category.' + category_id)
          pickup_tag = PickupTag.where(long_name: category_name).where.not(icon: nil).first
          profile_pickup = ProfilePickup.where(profile_id: profile_category.profile_id, pickup_id: pickup_tag.id).first
          unless profile_pickup
            profile_pickup = ProfilePickup.create!(profile_id: profile_category.profile_id, pickup_id: pickup_tag.id)
            profile_pickup.tag_list = profile_category.tag_list
            profile_pickup.save!
          end
        end
        
        #ActsAsTaggableOn::Tagging.all.where(taggable_type: 'ProfilePickup').each do |tagging|
        #  tagging.update!(taggable_type: 'ProfileCategory')
        #end
        
        ListingImage.where.not(category: nil).each do |listing_image|
          if listing_image.category.present?
            category_name = I18n.t('listing_images.category.' + listing_image.category)
            pickup_tag = PickupTag.where(long_name: category_name).where.not(icon: nil).first
            listing_image.update!(pickup_id: pickup_tag.id)
          end
        end
      end
    rescue ActiveRecord::Rollback
    end
  end
end
