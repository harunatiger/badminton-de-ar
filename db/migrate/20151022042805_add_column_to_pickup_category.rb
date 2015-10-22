class AddColumnToPickupCategory < ActiveRecord::Migration
  def change
    add_column :pickup_categories, :cover_image, :string
  end
end
