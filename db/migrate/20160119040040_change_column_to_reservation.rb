class ChangeColumnToReservation < ActiveRecord::Migration
  def up
    change_column :reservations, :schedule, :datetime, null: true
    change_column :reservations, :schedule_end, :date, null: true
  end

  def down
    change_column :reservations, :schedule, :datetime, null: false
    change_column :reservations, :schedule_end, :date, null: false
  end
end
