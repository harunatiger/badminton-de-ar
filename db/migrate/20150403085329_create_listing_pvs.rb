class CreateListingPvs < ActiveRecord::Migration
  def change
    create_table :listing_pvs do |t|
      t.references :listing, index: true
      t.date :viewed_at
      t.integer :pv, default: 0

      t.timestamps null: false
    end
    add_index :listing_pvs, [:viewed_at, :listing_id], unique: true
    add_foreign_key :listing_pvs, :listings
  end
end
