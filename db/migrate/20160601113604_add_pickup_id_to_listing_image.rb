class AddPickupIdToListingImage < ActiveRecord::Migration
  def change
    change_table :listing_images do |t|
      t.references :pickup, index: true
    end
    add_foreign_key :listing_images, :pickups, column: 'pickup_id'
  end
end
