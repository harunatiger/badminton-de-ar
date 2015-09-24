class AddDetailToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :time_required, :integer, default: 1
    add_column :reservations, :price, :integer, default: 0
    add_column :reservations, :option_price, :integer, default: 0
    add_column :reservations, :schedule_hour, :datetime
    add_column :reservations, :schedule_minute, :datetime
    add_column :reservations, :place, :string, default: ''
    add_column :reservations, :description, :text, default: ''
  end
end
