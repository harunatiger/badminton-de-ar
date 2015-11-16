class AddCoverImageSmallToPickupTag < ActiveRecord::Migration
  def change
    add_column :pickup_tags, :cover_image_small, :string, default: ''
  end
end
