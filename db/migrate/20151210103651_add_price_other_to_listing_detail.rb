class AddPriceOtherToListingDetail < ActiveRecord::Migration
  def change
    add_column :listing_details, :price_other, :integer, default: 0
  end
end
