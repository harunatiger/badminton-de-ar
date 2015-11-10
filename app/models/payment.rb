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
#  payment_status   :string           default("")
#  amount           :integer
#  currency_code    :string           default("")
#  email            :string           default("")
#  first_name       :string           default("")
#  last_name        :string           default("")
#  country_code     :string           default("")
#  transaction_date :datetime
#  refund_date      :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_payments_on_reservation_id  (reservation_id)
#

class Payment < ActiveRecord::Base
  belongs_to :reservation
  
  def amount_for_paypal
    self.amount * 100
  end
  
  def cancel_available
    self.updated_at.to_date + 60.days >= Time.zone.today
  end
end
