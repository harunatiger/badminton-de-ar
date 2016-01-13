class CreateListingDetailOptions < ActiveRecord::Migration
  def change
    create_table :listing_detail_options do |t|
      t.references :listing_detail, index: true
      t.references :option, index: true
      t.integer :price, default: 0, index: true
      t.timestamps null: false
    end
    add_foreign_key :listing_detail_options, :listing_details
    add_foreign_key :listing_detail_options, :options
  end
end
