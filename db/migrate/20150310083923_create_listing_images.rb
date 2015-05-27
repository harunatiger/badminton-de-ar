class CreateListingImages < ActiveRecord::Migration
  def change
    create_table :listing_images do |t|
      t.references :listing, index: true
      t.string :image, default: ''
      t.integer :order_num
      t.string :caption, default: ''

      t.timestamps null: false
    end
    add_foreign_key :listing_images, :listings
  end
end
