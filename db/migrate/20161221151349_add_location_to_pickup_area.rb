class AddLocationToPickupArea < ActiveRecord::Migration
  def change
    add_column :pickups, :longitude, :decimal, precision: 9, scale: 6
    add_column :pickups, :latitude, :decimal, precision: 9, scale: 6
  end
end
