class CreateListingDestinations < ActiveRecord::Migration
  def change
    create_table :listing_destinations do |t|
      t.references :listing, index: true, null: false
      t.string :location, null: false
      t.decimal :longitude,  precision: 9, scale: 6
      t.decimal :latitude,  precision: 9, scale: 6
      t.timestamps null: false
    end
    add_foreign_key :listing_destinations, :listings
  end
end
