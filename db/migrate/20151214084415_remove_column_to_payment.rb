class RemoveColumnToPayment < ActiveRecord::Migration
  def change
    remove_column :payments, :accepted_at, :datetime
  end
end
