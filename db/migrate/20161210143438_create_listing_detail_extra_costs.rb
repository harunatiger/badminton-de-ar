class CreateListingDetailExtraCosts < ActiveRecord::Migration
  def change
    create_table :listing_detail_extra_costs do |t|
      t.references :listing_detail, index: true, nil: false
      t.string :description, nil: false
      t.integer :price, nil: false, default: 0
      t.integer :for_each, nil: false
      t.timestamps null: false
    end
    add_foreign_key :listing_detail_extra_costs, :listing_details
  end
end
