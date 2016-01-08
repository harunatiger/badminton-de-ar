class CreateFavoriteListings < ActiveRecord::Migration
  def change
    create_table :favorite_listings do |t|
      t.references :user, index: true
      t.references :listing, index: true

      t.timestamps null: false
    end
    add_foreign_key :favorite_listings, :users
    add_foreign_key :favorite_listings, :listings
  end
end
