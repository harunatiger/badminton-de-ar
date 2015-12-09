class RenameColumnToPickups < ActiveRecord::Migration
  def change
    rename_column :pickups, :name, :short_name
    rename_column :pickup_categories, :name, :short_name
    rename_column :pickup_tags, :name, :short_name
    rename_column :pickup_areas, :name, :short_name
  end
end
