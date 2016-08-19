# == Schema Information
#
# Table name: reservation_withdrawals
#
#  id             :integer          not null, primary key
#  reservation_id :integer          not null
#  withdrawal_id  :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_reservation_withdrawals_on_reservation_id  (reservation_id)
#  index_reservation_withdrawals_on_withdrawal_id   (withdrawal_id)
#

class ReservationWithdrawal < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :withdrawal
end
