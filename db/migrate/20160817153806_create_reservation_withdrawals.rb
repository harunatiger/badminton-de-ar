class CreateReservationWithdrawals < ActiveRecord::Migration
  def change
    create_table :reservation_withdrawals do |t|
      t.references :reservation, index: true, null: false
      t.references :withdrawal, index: true, null: false
      t.timestamps null: false
    end
    add_foreign_key :reservation_withdrawals, :reservations
    add_foreign_key :reservation_withdrawals, :withdrawals
  end
end
