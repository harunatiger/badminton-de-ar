namespace :create_favorite_histories do
  desc 'create favorite_histories'
  task do: :environment do
    begin
      ActiveRecord::Base.transaction do
        FavoriteUser.all.each do |favorite_user|
          FavoriteUserHistory.create!(
            from_user_id: favorite_user.from_user_id,
            to_user_id: favorite_user.to_user_id,
            read_at: favorite_user.read_at,
            created_at: favorite_user.created_at
          )
        end

        fDisabled = GC.enable
        GC.start
        GC.disable if fDisabled
        
        FavoriteListing.all.each do |favorite_listing|
          FavoriteListingHistory.create!(
            from_user_id: favorite_listing.user_id,
            listing_id: favorite_listing.listing_id,
            read_at: favorite_listing.read_at,
            created_at: favorite_listing.created_at
          )
        end
        
      end
    rescue ActiveRecord::Rollback
    end
  end
end
