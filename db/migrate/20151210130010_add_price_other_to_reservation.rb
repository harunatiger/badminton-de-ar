class AddPriceOtherToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :price_other, :integer, default: 0
  end
end
