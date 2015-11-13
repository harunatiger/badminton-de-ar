class DropTablePickups < ActiveRecord::Migration
  def change
    drop_table :listing_pickup_areas
    drop_table :listing_pickup_categories
    drop_table :listing_pickup_tags
  end
end
