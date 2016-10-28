# == Schema Information
#
# Table name: ngevent_weeks
#
#  id         :integer          not null, primary key
#  listing_id :integer          not null
#  dow        :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  mode       :integer          default(0), not null
#  user_id    :integer
#
# Indexes
#
#  index_ngevent_weeks_on_dow         (dow)
#  index_ngevent_weeks_on_listing_id  (listing_id)
#

class NgeventWeek < ActiveRecord::Base
  belongs_to :user, class_name: 'User'
  belongs_to :listing, class_name: 'Listing'

  validates :user_id, presence: true

  scope :for_listing, -> (listing_id) { where('listing_id = ? or listing_id = ?', 0, listing_id) }
  scope :user_ngweeks, -> (user_id) { where('user_id = ?', user_id) }
  scope :mode, -> (mode) { where('mode = ?', mode) }

  # about mode
  # 0 : single listing
  # 1 : all listign

  def self.select_ngweeks(user_id, arry_ngweek)
    ngweeks_fixed = []
    arry_ngweek.each do |id|
      ngweeks = NgeventWeek.where(user_id: user_id, id: id).order(:mode)
      if ngweeks.present?
        ngweek = Hash.new
        ngweek_mode = ngweeks.first.mode
        ngweek.store('id', id)
        ngweek.store('category', 'week')
        ngweek.store('modenum', ngweeks.first.mode)
        if ngweek_mode == 1
          ngweek.store('title', '全ツアー')
          ngweek.store('mode', 'NG')
        else
          ngweek.store('title', ngweeks.first.listing.title)if ngweeks.first.listing.present?
          ngweek.store('mode', 'NG')
        end
        ngweeks_fixed << ngweek
      end
    end
    ngweeks_fixed
  end

  def self.select_ngweeks_for_user(user_id, dow)
    ngweeks = NgeventWeek.includes(:listing).where(user_id: user_id, dow: dow)
    ngweeks_fixed = []
    if ngweeks.present?
      ngweeks.each do |nw|
        ngweek = Hash.new
        ngweek_mode = nw.mode
        ngweek.store('id', nw.id)
        ngweek.store('category', 'week')
        ngweek.store('modenum', nw.mode)
        if ngweek_mode == 1
          ngweek.store('title', '全ツアー')
          ngweek.store('mode', 'NG')
        else
          ngweek.store('title', nw.listing.title)if nw.listing.present?
          ngweek.store('mode', 'NG')
        end
        ngweeks_fixed << ngweek
      end
    end
    ngweeks_fixed
  end

  def self.get_ngweeks_from_reservation(reservation)
    ngweeks = NgeventWeek.user_ngweeks(reservation.try('host_id')).for_listing(reservation.try('listing_id'))
    ngweeks
  end

  def self.get_ngweeks_from_listing(listing)
    ngweeks = NgeventWeek.user_ngweeks(listing.user_id).for_listing(listing.id)
    ngweeks
  end

  def self.fix_common_ngweeks(user_id)
    ngweeks = NgeventWeek.user_ngweeks(user_id).mode(1)
    ngweeks
  end

end
