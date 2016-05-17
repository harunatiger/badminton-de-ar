class AddInsuranceFeeToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :insurance_fee, :integer, default: 0
  end
end
