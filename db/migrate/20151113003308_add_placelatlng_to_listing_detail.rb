class AddPlacelatlngToListingDetail < ActiveRecord::Migration
  def change
    add_column :listing_details, :place_longitude, :decimal ,precision: 9, scale: 6, default: 0.0
    add_column :listing_details, :place_latitude, :decimal ,precision: 9, scale: 6, default: 0.0
  end
end
