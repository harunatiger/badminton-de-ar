# == Schema Information
#
# Table name: ngevents
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  reservation_id :integer
#  listing_id     :integer
#  start          :date             not null
#  end            :date             not null
#  end_bk         :date
#  mode           :integer          default(0), not null
#  color          :string           default("gray")
#  active         :integer          default(1)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_ngevents_on_mode            (mode)
#  index_ngevents_on_reservation_id  (reservation_id)
#  index_ngevents_on_user_id         (user_id)
#

class Ngevent < ActiveRecord::Base
  belongs_to :user, class_name: 'User'
  belongs_to :reservation, class_name: 'Reservation'
  belongs_to :listing, class_name: 'Listing'

  validates :user_id, presence: true
  validates :start, presence: true
  #validates :end, presence: true, date: { after: :start }

  def self.change_date(ngevent_params, reservation_id)
    ngevent_before = Ngevent.where(user_id: ngevent_params['user_id'],guest_id: ngevent_params['guest_id']).first
    if ngevent_before.present?
      ngevent_before.update(ngevent_params)
    else
      self.create(ngevent_params)
    end
  end

  def is_settable(current_event_id, listing_id)
    current_user_id = self.user_id
    current_date_array = self.current_date_array
    exist_date_array = Ngevent.exist_date_array(current_user_id, current_event_id, listing_id)
    product = current_date_array & exist_date_array
    product.size.zero? ? true : false
  end

  def current_date_array
    current_date_array = []
    (self.start.to_date..self.end.to_date - 1.day).each{ |i| current_date_array << i }
    current_date_array
  end

  def self.exist_date_array(current_user_id, id, listing_id)
    ngs = Ngevent.where(user_id: current_user_id, listing_id: listing_id, active: 1).where.not(id: id)
    ng_array = []
    ngs.each do |ng|
      ns = ng.start.to_date
      ne = pp ng.end.to_date - 1.day
      (ns..ne).each{ |i| ng_array << i }
    end
    ng_array
  end

  def self.get_ngdates(listing_id)
    ngevents = Ngevent.where(listing_id: listing_id, active: 1)
    ngdates = []
    ngevents.each do |ngevent|
      start_date = ngevent['start']
      end_date = ngevent['end_bk']
      while start_date <= end_date do
        ngdates << (start_date - 1.day).strftime("%Y.%m.%d")
        start_date = start_date + 1.day
      end
    end
    ngdates
  end
  
  def self.get_ngdates_except_self(reservation)
    ngevents = Ngevent.where(listing_id: reservation.try('listing_id'), active: 1)
    ngevents.where.not(guest_id: reservation.try(:guest_id) || 0) if ngevents.present?
    ngdates = []
    ngevents.each do |ngevent|
      start_date = ngevent['start']
      end_date = ngevent['end_bk']
      while start_date <= end_date do
        ngdates << (start_date - 1.day).strftime("%Y.%m.%d")
        start_date = start_date + 1.day
      end
    end
    ngdates
  end

  def self.fix_ngdates_for_show(user_id, listing_id)
    ngevents = Ngevent.where(user_id: user_id, listing_id: listing_id, active: 1)
    ngevents_fixed = []
    ngevents.each do |ngevent|
      ngevent['end'] = (ngevent['end'] + 1.day).strftime("%Y.%m.%d")
      ngevents_fixed << ngevent
    end
    ngevents_fixed
  end
end
