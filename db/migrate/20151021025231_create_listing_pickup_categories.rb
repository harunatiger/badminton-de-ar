class CreateListingPickupCategories < ActiveRecord::Migration
  def change
    create_table :listing_pickup_categories do |t|
      t.references :listing, index: true
      t.references :pickup_category, index: true

      t.timestamps null: false
    end
  end
end
