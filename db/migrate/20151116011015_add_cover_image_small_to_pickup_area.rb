class AddCoverImageSmallToPickupArea < ActiveRecord::Migration
  def change
    add_column :pickup_areas, :cover_image_small, :string, default: ''
  end
end
