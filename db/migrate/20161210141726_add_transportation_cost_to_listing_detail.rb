class AddTransportationCostToListingDetail < ActiveRecord::Migration
  def change
    add_column :listing_details, :transportation_cost_main, :integer, default: 0
    add_column :listing_details, :transportation_cost_support, :integer, default: 0
    add_column :reservations, :transportation_cost_main, :integer, default: 0
    add_column :reservations, :transportation_cost_support, :integer, default: 0
  end
end
