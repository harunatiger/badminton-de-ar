class ChangeAmountTypeOfPayment < ActiveRecord::Migration
  def change
    change_column :payments, :amount, :decimal
    add_column :payments, :exchange_rate, :decimal
  end
end
