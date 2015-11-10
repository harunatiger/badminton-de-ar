class AddOptionPricePerPersonToListingDetail < ActiveRecord::Migration
  def change
    add_column :listing_details, :option_price_per_person, :integer, after: :option_price, default: 0
  end
end
