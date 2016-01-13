# == Schema Information
#
# Table name: reservation_options
#
#  id             :integer          not null, primary key
#  reservation_id :integer
#  option_id      :integer
#  price          :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_reservation_options_on_option_id       (option_id)
#  index_reservation_options_on_price           (price)
#  index_reservation_options_on_reservation_id  (reservation_id)
#

class ReservationOption < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :option
end
