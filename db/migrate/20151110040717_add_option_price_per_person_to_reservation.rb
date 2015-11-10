class AddOptionPricePerPersonToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :option_price_per_person, :integer, after: :option_price, default: 0
  end
end
