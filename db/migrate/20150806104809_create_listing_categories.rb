class CreateListingCategories < ActiveRecord::Migration
  def change
    create_table :listing_categories do |t|
      t.references :listing, index: true
      t.references :category, index: true

      t.timestamps null: false
    end
    
    add_foreign_key :listing_categories, :listings
    add_foreign_key :listing_categories, :categories
  end
end
