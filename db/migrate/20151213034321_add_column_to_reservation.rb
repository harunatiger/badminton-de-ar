class AddColumnToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :refund_rate, :integer, default: 0
  end
end
