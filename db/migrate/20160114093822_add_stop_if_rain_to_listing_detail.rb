class AddStopIfRainToListingDetail < ActiveRecord::Migration
  def change
    add_column :listing_details, :stop_if_rain, :boolean, default: false
  end
end
