namespace :create_pickup_tag do
  desc 'create pickup_tag'
  task do: :environment do
    begin
      ActiveRecord::Base.transaction do
        PickupTag.destroy_all
        PickupTag.create!(short_name: 'Spa and Relaxation', long_name: 'Spa and Relaxation', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/spa_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/spa_icon_02.png").open)

        PickupTag.create!(short_name: 'Cultural Sites', long_name: 'Cultural Sites', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/culturalsites_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/culturalsites_icon_02.png").open)

        PickupTag.create!(short_name: 'Food and Drink', long_name: 'Food and Drink', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/food_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/food_icon_02.png").open)

        PickupTag.create!(short_name: 'Shopping', long_name: 'Shopping', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/shopping_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/shopping_icon_02.png").open)

        PickupTag.create!(short_name: 'Outdoors', long_name: 'Outdoors', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/outdoor_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/outdoor_icon_02.png").open)

        PickupTag.create!(short_name: 'Sports', long_name: 'Sports', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/sports_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/sports_icon_02.png").open)

        PickupTag.create!(short_name: 'Gardens', long_name: 'Gardens', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/garden_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/garden_icon_02.png").open)

        PickupTag.create!(short_name: 'Tourist Hotspots', long_name: 'Tourist Hotspots', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/hotspots_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/hotspots_icon_02.png").open)

        PickupTag.create!(short_name: 'Art', long_name: 'Art', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/art_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/art_icon_02.png").open)

        PickupTag.create!(short_name: 'Manga and Anime', long_name: 'Manga and Anime', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/anime_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/anime_icon_02.png").open)
        
        PickupTag.create!(short_name: 'Onsen', long_name: 'Onsen', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/onsen_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/onsen_icon_02.png").open)

        PickupTag.create!(short_name: 'Theme Parks', long_name: 'Theme Parks', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/themepark_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/themepark_icon_02.png").open)

        PickupTag.create!(short_name: 'Entertainment', long_name: 'Entertainment', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/entertainment_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/entertainment_icon_02.png").open)

        PickupTag.create!(short_name: 'Experiences', long_name: 'Experiences', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/experience_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/experience_icon_02.png").open)

        PickupTag.create!(short_name: 'Night Life', long_name: 'Night Life', cover_image: Rails.root.join("app/assets/images/no-image-1024x640.gif").open, cover_image_small: Rails.root.join("app/assets/images/no-image-640x640.gif").open, icon: Rails.root.join("app/assets/images/image_category/nightlife_icon_01.png").open, icon_small: Rails.root.join("app/assets/images/image_category/nightlife_icon_02.png").open)
      end
    rescue ActiveRecord::Rollback
    end
  end
end
