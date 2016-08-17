class CreateWithdrawals < ActiveRecord::Migration
  def change
    create_table :withdrawals do |t|
      t.references :user, index: true, null: false
      t.integer :amount, null: false, default: 0
      t.datetime :requested_at, index: true
      t.datetime :paid_at, index: true
      t.timestamps null: false
    end
    add_foreign_key :withdrawals, :users
  end
end
