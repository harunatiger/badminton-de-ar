class ChangeColumnReservation < ActiveRecord::Migration
  def change
    remove_column :reservations, :option_price, :integer
    remove_column :reservations, :option_price_per_person, :integer
    remove_column :reservations, :price_other, :integer
    add_column :reservations, :price_for_support, :integer, default: 0
    add_column :reservations, :price_for_both_guides, :integer, default: 0
    add_column :reservations, :space_option, :boolean, default: true
    add_column :reservations, :space_rental, :integer, default: 0
    add_column :reservations, :car_option, :boolean, default: true
    add_column :reservations, :car_rental, :integer, default: 0
    add_column :reservations, :gas, :integer, default: 0
    add_column :reservations, :highway, :integer, default: 0
    add_column :reservations, :parking, :integer, default: 0
    add_column :reservations, :guests_cost, :integer, default: 0
    add_column :reservations, :included_guests_cost, :text, default: ''
  end
end
