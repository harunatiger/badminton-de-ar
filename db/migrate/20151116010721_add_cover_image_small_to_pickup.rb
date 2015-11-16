class AddCoverImageSmallToPickup < ActiveRecord::Migration
  def change
    add_column :pickups, :cover_image_small, :string, default: ''
  end
end
