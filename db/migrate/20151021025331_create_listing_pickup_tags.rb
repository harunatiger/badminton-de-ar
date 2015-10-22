class CreateListingPickupTags < ActiveRecord::Migration
  def change
    create_table :listing_pickup_tags do |t|
      t.references :listing, index: true
      t.references :pickup_tag, index: true

      t.timestamps null: false
    end
  end
end
