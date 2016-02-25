class AddStatusToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :status, :integer, default: 0, index: true
    Payment.all.each do |p|
      p.update(status: 1) if p.payment_status == 'Confirmed'
      p.update(status: 2) if p.payment_status == 'Completed'
      p.update(status: 3) if p.payment_status == 'Refunded'
      p.update(status: 4) if p.payment_status == 'Cancelled'
    end
    remove_column :payments, :payment_status
  end
end
