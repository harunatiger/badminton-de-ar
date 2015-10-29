class CreateListingPickups < ActiveRecord::Migration
  def change
    create_table :listing_pickups do |t|
      t.references :listing, index: true
      t.references :pickup, index: true
      t.timestamps null: false
    end
  end
end
