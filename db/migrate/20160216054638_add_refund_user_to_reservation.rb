class AddRefundUserToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :refund_user, :integer, default: 0
  end
end
