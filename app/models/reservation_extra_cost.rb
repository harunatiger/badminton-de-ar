# == Schema Information
#
# Table name: reservation_extra_costs
#
#  id             :integer          not null, primary key
#  reservation_id :integer
#  description    :string
#  price          :integer          default(0)
#  for_each       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_reservation_extra_costs_on_reservation_id  (reservation_id)
#

class ReservationExtraCost < ActiveRecord::Base
  belongs_to :reservation
  enum for_each: { team: 0, person: 1}
end
