class CreateListingPickupAreas < ActiveRecord::Migration
  def change
    create_table :listing_pickup_areas do |t|
      t.references :listing, index: true
      t.references :pickup_area, index: true

      t.timestamps null: false
    end
  end
end
