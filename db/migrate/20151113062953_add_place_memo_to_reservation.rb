class AddPlaceMemoToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :place_memo, :text, default: ''
  end
end
