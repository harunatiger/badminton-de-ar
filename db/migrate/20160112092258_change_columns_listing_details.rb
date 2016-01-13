class ChangeColumnsListingDetails < ActiveRecord::Migration
  def change
    remove_column :listing_details, :option_price, :integer
    remove_column :listing_details, :option_price_per_person, :integer
    remove_column :listing_details, :price_other, :integer
    remove_column :listing_details, :included_other, :integer
    remove_column :listing_details, :included, :integer
    add_column :listing_details, :price_for_support, :integer, default: 0
    add_column :listing_details, :price_for_both_guides, :integer, default: 0
    add_column :listing_details, :space_option, :boolean, default: true
    add_column :listing_details, :space_rental, :integer, default: 0
    add_column :listing_details, :car_option, :boolean, default: true
    add_column :listing_details, :car_rental, :integer, default: 0
    add_column :listing_details, :gas, :integer, default: 0
    add_column :listing_details, :highway, :integer, default: 0
    add_column :listing_details, :parking, :integer, default: 0
    add_column :listing_details, :guests_cost, :integer, default: 0
    add_column :listing_details, :included_guests_cost, :text, default: ''
  end
end
