class ChangeTimeRequiredForReservation < ActiveRecord::Migration
  def up
    change_column :reservations, :time_required, :decimal, precision: 9, scale: 6, default: 0.0
  end

  def down
    change_column :reservations, :time_required, :intger
  end
end
