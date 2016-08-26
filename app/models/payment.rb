# == Schema Information
#
# Table name: payments
#
#  id               :integer          not null, primary key
#  reservation_id   :integer
#  token            :string           default("")
#  payer_id         :string           default("")
#  payers_status    :string           default("")
#  transaction_id   :string           default("")
#  amount           :decimal(, )
#  currency_code    :string           default("")
#  email            :string           default("")
#  first_name       :string           default("")
#  last_name        :string           default("")
#  country_code     :string           default("")
#  transaction_date :datetime
#  refund_date      :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  status           :integer          default(0)
#  exchange_rate    :decimal(, )
#
# Indexes
#
#  index_payments_on_reservation_id  (reservation_id)
#

class Payment < ActiveRecord::Base
  include Payments

  belongs_to :reservation

  scope :with_reservation, -> { joins(:reservation) }
  scope :term, -> (from, to){ where('(schedule >= ? AND schedule <= ? AND progress = ?) OR (reservations.updated_at >= ? AND reservations.updated_at <= ? AND progress = ?)', from.beginning_of_day,to.end_of_day, 3, from.beginning_of_day,to.end_of_day, 6 ) }
  scope :order_by_schedule, -> { order('schedule') }

  enum status: { default: 0, confirmed: 1, completed: 2, refunded: 3, refund_disabled: 4}

  def amount_for_paypal
    self.amount * 100
  end

  def cancel_available(reservation)
    self.updated_at.to_date + 60.days >= Time.zone.today and reservation.before_days?
  end

  def cancel_available_for_withdraw(reservation)
    self.updated_at.to_date + 60.days >= Time.zone.today
  end

  def refund_amount_for_paypal(percentage)
    if ['JPY', 'HUF', 'TWD'].index(self.currency_code).present?
      (self.amount - (self.amount / (100 / percentage)).ceil.to_i) * 100
    else
      (self.amount - (self.amount / (100 / percentage)).round(2)) * 100
    end
  end
end
