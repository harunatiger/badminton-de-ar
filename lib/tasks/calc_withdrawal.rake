namespace :calc_withdrawal do
  desc 'calc withdrawal'
  task do: :environment do
    day = Time.zone.today - 1.day
    p reservations = Reservation.need_to_guide_pay.finished_when(day, day)
    
    reservations.each do |reservation|
      if reservation.withdrawals.blank?
        main_guide_payment = reservation.main_guide_payment
        support_guide_payment = reservation.support_guide_payment

        if main_guide_payment >= 0
          withdrawal = Withdrawal.where(user_id: reservation.host_id).credit.first
          if withdrawal.present?
            withdrawal.amount = withdrawal.amount + main_guide_payment
            if withdrawal.save
              ReservationWithdrawal.create(reservation_id: reservation.id, withdrawal_id: withdrawal.id)
            end
          else
            if withdrawal = Withdrawal.create(user_id: reservation.host_id, amount: main_guide_payment)
              ReservationWithdrawal.create(reservation_id: reservation.id, withdrawal_id: withdrawal.id)
            end
          end
        end

        if reservation.pg_completion? and support_guide_payment >= 0
          withdrawal = Withdrawal.where(user_id: reservation.pair_guide_id).credit.first
          if withdrawal.present?
            withdrawal.amount = withdrawal.amount + support_guide_payment
            if withdrawal.save
              ReservationWithdrawal.create(reservation_id: reservation.id, withdrawal_id: withdrawal.id)
            end
          else
            if withdrawal = Withdrawal.create(user_id: reservation.pair_guide_id, amount: support_guide_payment)
              ReservationWithdrawal.create(reservation_id: reservation.id, withdrawal_id: withdrawal.id)
            end
          end
        end
      end
    end
  end
end
