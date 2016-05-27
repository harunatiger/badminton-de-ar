class AddIconImageToPickup < ActiveRecord::Migration
  def change
    add_column :pickups, :icon, :string, default: ''
    add_column :pickups, :icon_small, :string, default: ''
  end
end
