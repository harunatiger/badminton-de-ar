class AddOptionColumnsToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :bicycle_option, :boolean, default: false
    add_column :reservations, :bicycle_rental, :integer, default: 0
    add_column :reservations, :other_option, :boolean, default: false
    add_column :reservations, :other_cost, :integer, default: 0

    Reservation.all.each do |r|
      price_both = r.price_for_both_guides
      price_space = r.space_rental
      m_price = price_both + price_space
      r.update!(other_option: true, other_cost: m_price) if m_price != 0
    end
  end
end
