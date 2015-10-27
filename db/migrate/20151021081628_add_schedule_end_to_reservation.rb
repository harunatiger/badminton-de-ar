class AddScheduleEndToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :schedule_end, :date, after: :schedule
  end
end
