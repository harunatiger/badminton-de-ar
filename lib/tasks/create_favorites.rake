namespace :create_favorites do
  desc 'create favorites'
  task do: :environment do
    begin
      ActiveRecord::Base.transaction do
        con = ActiveRecord::Base.connection
        favorite_users = con.execute("select * from favorite_users;")
        favorite_users.each do |favorite_user|
          Favorite.create!(
            from_user_id: favorite_user.from_user_id,
            to_user_id: favorite_user.to_user_id,
            read_at: favorite_user.read_at,
            type: 'FavoriteUser',
            created_at: favorite_user.created_at,
            updated_at: favorite_user.updated_at
          )
        end

        fDisabled = GC.enable
        GC.start
        GC.disable if fDisabled
        
        con = ActiveRecord::Base.connection
        favorite_listings = con.execute("select * from favorite_listings;")
        FavoriteListing.all.each do |favorite_listing|
          Favorite.create!(
            from_user_id: favorite_listing.user_id,
            listing_id: favorite_listing.listing_id,
            read_at: favorite_listing.read_at,
            type: 'FavoriteListing',
            created_at: favorite_listing.created_at,
            updated_at: favorite_listing.updated_at
          )
        end
        
      end
    rescue ActiveRecord::Rollback
    end
  end
end
