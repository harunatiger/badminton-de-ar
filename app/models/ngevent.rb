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
#  guest_id       :integer
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

  scope :for_listing, -> (listing_id) { where('listing_id = ? or listing_id = ?', 0, listing_id) }
  scope :user_ngevents, -> (user_id) { where('user_id = ? and active = ?', user_id, 1) }
  scope :listing_ngevents, -> (listing_id) { where('listing_id = ?', listing_id) }
  scope :mode, -> (mode) { where('mode = ?', mode) }
  scope :common_ngday, -> { where('mode = ? or mode = ? or mode = ?', 1, 2, 3) }

  def self.set_date(reservation)
    ngevent_params = Hash[
          'reservation_id' => reservation.id,
          'listing_id' => reservation.listing_id,
          'user_id' => reservation.host_id,
          'guest_id' => reservation.guest_id,
          'start' => reservation.schedule,
          'end' => reservation.schedule_end,
          'end_bk' => reservation.schedule_end,
          'mode' => 2,  # 1:reservation_mode,  2:requet_mode
          'active' => 1,# 0:no actice
          'color' => 'red'
          ]
    self.create(ngevent_params)
  end

  def self.offer(reservation)
    ngevent_params = Hash[
          'reservation_id' => reservation.id,
          'listing_id' => reservation.listing_id,
          'user_id' => reservation.host_id,
          'guest_id' => reservation.guest_id,
          'start' => reservation.schedule,
          'end' => reservation.schedule_end,
          'end_bk' => reservation.schedule_end,
          'mode' => 2,  # 1:reservation_mode,  2:requet_mode
          'active' => 1,# 0:no actice
          'color' => 'red'
          ]
    ng_event = self.find_by(reservation_id: reservation.id)
    return ng_event.update(ngevent_params) if ng_event.present?
    return self.create(ngevent_params)
  end

  def self.cancel(reservation)
    ng_event = self.where(reservation_id: reservation.id)
    ng_event.destroy_all
  end

  def self.accept(reservation)
    ng_event = self.find_by(reservation_id: reservation.id)
    ng_event.update_attributes({:active => 1, :mode => 1})
  end

  def is_settable(current_event_id, listing_id)
    current_user_id = self.user_id
    current_date_array = self.current_date_array
    exist_date_array = Ngevent.exist_date_array(current_user_id, current_event_id, listing_id)
    product = current_date_array & exist_date_array
    product.size.zero? ? true : false
  end

  def self.is_settable_from_reservation(reservation)
    current_date_array = current_date_array_from_reservation(reservation)
    exist_date_array = Ngevent.exist_date_array_from_reservation(reservation.try('host_id'), reservation.try('id'), reservation.try('listing_id'))
    product = current_date_array & exist_date_array
    pp product
    product.size.zero? ? true : false
  end

  def current_date_array
    current_date_array = []
    #(self.start.to_date..self.end.to_date - 1.day).each{ |i| current_date_array << i }
    (self.start.to_date..self.end.to_date).each{ |i| current_date_array << i }
    current_date_array
  end

  def self.current_date_array_from_reservation(reservation)
    current_date_array = []
    #(self.start.to_date..self.end.to_date - 1.day).each{ |i| current_date_array << i }
    (reservation.schedule.to_date..reservation.schedule_end.to_date).each{ |i| current_date_array << i }
    current_date_array
  end

  def self.exist_date_array(current_user_id, id, listing_id)
    ngs = Ngevent.where(user_id: current_user_id, listing_id: listing_id, active: 1).where.not(id: id)
    ng_array = []
    ngs.each do |ng|
      ns = ng.start.to_date
      #ne = pp ng.end.to_date - 1.day
      ne = pp ng.end.to_date
      (ns..ne).each{ |i| ng_array << i }
    end
    ng_array
  end

  def self.exist_date_array_from_reservation(user_id, reservation_id, listing_id)
    reservation_ngevents = Ngevent.user_ngevents(user_id).where.not(reservation_id: reservation_id)
    all_ngevents = Ngevent.user_ngevents(user_id).for_listing(listing_id).where(reservation_id: nil)
    ngs = all_ngevents.to_a + reservation_ngevents.to_a
    ng_array = []
    ngs.each do |ng|
      ns = ng.start.to_date
      #ne = pp ng.end.to_date - 1.day
      ne = pp ng.end.to_date
      (ns..ne).each{ |i| ng_array << i }
    end
    ng_array
  end

  def self.get_ngdates(listing)
    listing_ngevents = Ngevent.user_ngevents(listing.try('user_id')).listing_ngevents(listing.try('id'))
    all_ngevents = Ngevent.user_ngevents(listing.user_id).common_ngday
    ngevents = all_ngevents.to_a + listing_ngevents.to_a
    ngdates = []
    ngevents.each do |ngevent|
      start_date = ngevent['start']
      end_date = ngevent['end_bk']
      while start_date <= end_date do
        ngdates << start_date.strftime("%Y.%m.%d")
        start_date = start_date + 1.day
      end
    end
    ngdates
  end

  def self.get_ngdates_from_reservation(reservation)
    ngevents = Ngevent.user_ngevents(reservation.try('host_id')).listing_ngevents(reservation.try('listing_id'))
    ngdates = []
    ngevents.each do |ngevent|
      start_date = ngevent['start']
      end_date = ngevent['end_bk']
      while start_date <= end_date do
        ngdates << start_date.strftime("%Y.%m.%d")
        start_date = start_date + 1.day
      end
    end
    ngdates
  end

  def self.get_ngdates_from_listing(listing)
    listing_ngevents = Ngevent.user_ngevents(listing.user_id).listing_ngevents(listing.id)
    all_ngevents = Ngevent.user_ngevents(listing.user_id).common_ngday
    ngevents = all_ngevents.to_a + listing_ngevents.to_a
    ngdates = []
    ngevents.each do |ngevent|
      start_date = ngevent['start']
      end_date = ngevent['end_bk']
      while start_date <= end_date do
        ngdates << start_date.strftime("%Y.%m.%d")
        start_date = start_date + 1.day
      end
    end
    ngdates
  end

  def self.fix_common_ngdays(user_id)
    ngevents = Ngevent.user_ngevents(user_id).common_ngday
    ngdates = []
    ngevents.each do |ngevent|
      start_date = ngevent['start']
      end_date = ngevent['end_bk']
      while start_date <= end_date do
        ngdates << start_date.strftime("%Y.%m.%d")
        start_date = start_date + 1.day
      end
    end
    ngdates
  end

  def self.get_ngdates_except_request(reservation, listing_id)
    reservation_ngevents = Ngevent.user_ngevents(reservation.try('host_id')).where.not(reservation_id: reservation.try('id'))
    all_ngevents = Ngevent.user_ngevents(reservation.try('host_id')).for_listing(listing_id).where(reservation_id: nil)
    ngevents = all_ngevents.to_a + reservation_ngevents.to_a
    ngdates = []
    ngevents.each do |ngevent|
      start_date = ngevent['start']
      end_date = ngevent['end_bk']
      while start_date <= end_date do
        ngdates << start_date.strftime("%Y.%m.%d")
        start_date = start_date + 1.day
      end
    end
    ngdates
  end

  def self.fix_ngdates_for_show(user_id)
    ngevents = Ngevent.user_ngevents(user_id).mode(0)
    ngevents_fixed = []
    ngevents.each do |ngevent|
      ngevent['end'] = (ngevent['end'] + 1.day).strftime("%Y.%m.%d")
      ngevents_fixed << ngevent
    end
    ngevents_fixed
  end

  def self.fix_reservation_ngdays_for_show(user_id)
    ngevents = Ngevent.user_ngevents(user_id).mode(1)
    ngevents_fixed = []
    ngevents.each do |ngevent|
      ngevent['end'] = (ngevent['end'] + 1.day).strftime("%Y.%m.%d")
      ngevents_fixed << ngevent
    end
    ngevents_fixed
  end

  def self.fix_request_ngdays_for_show(user_id)
    ngevents = Ngevent.user_ngevents(user_id).mode(2)
    ngevents_fixed = []
    ngevents.each do |ngevent|
      ngevent['end'] = (ngevent['end'] + 1.day).strftime("%Y.%m.%d")
      ngevents_fixed << ngevent
    end
    ngevents_fixed
  end

  def self.fix_common_ngdays_for_show(user_id)
    ngevents = Ngevent.user_ngevents(user_id).mode(3)
    ngevents_fixed = []
    ngevents.each do |ngevent|
      ngevent['end'] = (ngevent['end'] + 1.day).strftime("%Y.%m.%d")
      ngevents_fixed << ngevent
    end
    ngevents_fixed
  end

  def self.select_ngdays(user_id, arry_ngday)
    ngevents_fixed = []
    arry_ngday.each do |id|
      ngevents = Ngevent.where(user_id: user_id, id: id, active: 1).order(:mode)
      if ngevents.present?
        ngday = Hash.new
        ngday_mode = ngevents.first.mode
        ngday.store('modenum', ngevents.first.mode)
        ngday.store('id', id)
        ngday.store('category', 'day')
        if ngday_mode == 3
          ngday.store('title', '全ツアー')
          ngday.store('mode', 'NG')
        else
          ngday.store('title', ngevents.first.listing.title)if ngevents.first.listing.present?
          if ngday_mode == 0
            ngday.store('mode', 'NG')
          elsif ngday_mode == 1
            ngday.store('mode', '予約確定')
          elsif ngday_mode == 2
            ngday.store('mode', 'リクエスト')
          end
        end
        ngevents_fixed << ngday
      end
    end
    ngevents_fixed
  end
end
