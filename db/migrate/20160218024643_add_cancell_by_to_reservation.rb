class AddCancellByToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :cancel_by, :integer, default: 0
    Payment.all.each do |p|
      r = p.reservation
      if p.payment_status  == 'Refunded'
        if r.refund_rate == 100 && r.canceled_after_accepted?
          cancel_by = 2
        elsif r.refund_rate == 50 && r.canceled_after_accepted?
          cancel_by = 3
        else
          cancel_by = 4
        end
      else
        if r.refund_rate == 0 && r.canceled_after_accepted?
          cancel_by = 4
        else
          cancel_by = 0
        end
      end
      r.record_timestamps = false
      r.update(cancel_by: cancel_by)
      r.record_timestamps = true
    end
  end
end
