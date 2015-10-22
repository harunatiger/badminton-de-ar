class AddColumnToPickupTag < ActiveRecord::Migration
  def change
    add_column :pickup_tags, :cover_image, :string
  end
end
