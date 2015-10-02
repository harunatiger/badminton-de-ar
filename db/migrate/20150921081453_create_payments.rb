class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :reservation, index: true
      t.string :token, default: ''
      t.string :payer_id, default: ''
      t.string :payers_status, default: ''
      t.string :transaction_id, default: ''
      t.string :payment_status, default: ''
      t.integer :amount
      t.string :currency_code, default: ''
      t.string :email, default: ''
      t.string :first_name, default: ''
      t.string :last_name, default: ''
      t.string :country_code, default: ''
      t.datetime :transaction_date
      t.datetime :refund_date
      t.timestamps null: false
    end
    add_foreign_key :payments, :reservations
  end
end
