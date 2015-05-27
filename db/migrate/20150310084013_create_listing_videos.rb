class CreateListingVideos < ActiveRecord::Migration
  def change
    create_table :listing_videos do |t|
      t.references :listing, index: true
      t.string :video, default: ''
      t.integer :order_num
      t.string :caption, default: ''

      t.timestamps null: false
    end
    add_foreign_key :listing_videos, :listings
  end
end
