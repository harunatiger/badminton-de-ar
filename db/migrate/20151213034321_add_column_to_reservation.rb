class AddColumnToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :refund_rate, :integer, default: 0
    add_column :payments, :accepted_at, :datetime
  end
end
