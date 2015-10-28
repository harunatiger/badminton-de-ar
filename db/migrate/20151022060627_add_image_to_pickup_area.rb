class AddImageToPickupArea < ActiveRecord::Migration
  def change
    add_column :pickup_areas, :cover_image, :string
  end
end
