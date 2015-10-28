class SinglePickupFromListings < ActiveRecord::Migration
  def change
    add_column :pickup_areas, :selected_listing, :integer
    add_column :pickup_categories, :selected_listing, :integer
    add_column :pickup_tags, :selected_listing, :integer
  end
end
