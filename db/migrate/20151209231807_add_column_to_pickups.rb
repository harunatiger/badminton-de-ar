class AddColumnToPickups < ActiveRecord::Migration
  def change
    add_column :pickups, :long_name, :string, default: '', :after => :name
    add_column :pickup_categories, :long_name, :string, default: '', :after => :name
    add_column :pickup_tags, :long_name, :string, default: '', :after => :name
    add_column :pickup_areas, :long_name, :string, default: '', :after => :name
  end
end
