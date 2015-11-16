class AddCoverImageSmallToPickupCategory < ActiveRecord::Migration
  def change
    add_column :pickup_categories, :cover_image_small, :string, default: ''
  end
end
