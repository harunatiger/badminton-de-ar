class ChangeScheduleInReservation < ActiveRecord::Migration
  def up
    change_column :reservations, :schedule, :datetime, null: false
  end

  def down
    change_column :reservations, :schedule, :date
  end
end
