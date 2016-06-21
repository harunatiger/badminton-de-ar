# == Schema Information
#
# Table name: reservations
#
#  id                     :integer          not null, primary key
#  host_id                :integer
#  guest_id               :integer
#  listing_id             :integer
#  schedule               :datetime
#  num_of_people          :integer          default(0), not null
#  msg                    :text             default("")
#  progress               :integer          default(0), not null
#  reason                 :text             default("")
#  review_mail_sent_at    :datetime
#  review_expiration_date :datetime
#  review_landed_at       :datetime
#  reviewed_at            :datetime
#  reply_mail_sent_at     :datetime
#  reply_landed_at        :datetime
#  replied_at             :datetime
#  review_opened_at       :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  time_required          :decimal(9, 6)    default(0.0)
#  price                  :integer          default(0)
#  place                  :string           default("")
#  description            :text             default("")
#  schedule_end           :date
#  place_memo             :text             default("")
#  campaign_id            :integer
#  refund_rate            :integer          default(0)
#  price_for_support      :integer          default(0)
#  price_for_both_guides  :integer          default(0)
#  space_option           :boolean          default(TRUE)
#  space_rental           :integer          default(0)
#  car_option             :boolean          default(TRUE)
#  car_rental             :integer          default(0)
#  gas                    :integer          default(0)
#  highway                :integer          default(0)
#  parking                :integer          default(0)
#  guests_cost            :integer          default(0)
#  included_guests_cost   :text             default("")
#  cancel_by              :integer          default(0)
#  pair_guide_id          :integer
#  pair_guide_status      :integer          default(0)
#  bicycle_option         :boolean          default(FALSE)
#  bicycle_rental         :integer          default(0)
#  other_option           :boolean          default(FALSE)
#  other_cost             :integer          default(0)
#  insurance_fee          :integer          default(0)
#
# Indexes
#
#  index_reservations_on_campaign_id    (campaign_id)
#  index_reservations_on_guest_id       (guest_id)
#  index_reservations_on_host_id        (host_id)
#  index_reservations_on_listing_id     (listing_id)
#  index_reservations_on_pair_guide_id  (pair_guide_id)
#

class Reservation < ActiveRecord::Base
  include DatetimeIntegratable
  before_save :set_price

  belongs_to :user, class_name: 'User', foreign_key: 'host_id'
  belongs_to :user, class_name: 'User', foreign_key: 'guest_id'
  belongs_to :user, class_name: 'User', foreign_key: 'pair_guide_id'
  belongs_to :listing
  belongs_to :campaign
  has_many :reviews
  has_one :payment
  has_many :ngevents, dependent: :destroy

  #Progress 4&5 are not used. Should delete records of progress 4 some day.
  enum progress: { requested: 0, canceled: 1, under_construction: 2, accepted: 3, rejected: 4, listing_closed: 5, canceled_after_accepted: 6}
  enum cancel_by: { default: 0, guide: 1, guest_before_weeks: 2, guest_before_days: 3, guest_less_than_days: 4}
  enum pair_guide_status: { pg_default: 0, pg_under_construction: 1, pg_offering: 2, pg_completion: 3}

  attr_accessor :message_thread_id
  attr_accessor :campaign_code
  accepts_nested_attributes_for :payment

  validates :host_id, presence: true
  validates :guest_id, presence: true
  validates :listing_id, presence: true, if: :progress_is_not_under_construction?
  validates :schedule, presence: true, if: :progress_is_not_under_construction?
  validates :schedule_end, presence: true, if: :progress_is_not_under_construction?
  validates :num_of_people, presence: true
  validates :progress, presence: true
  #validates :price, presence: true

  scope :as_guest, -> user_id { where(guest_id: user_id) }
  scope :as_host, -> user_id { where(host_id: user_id) }
  scope :as_host_and_pair_guide, -> user_id { where('(pair_guide_id = ? and pair_guide_status = ?) or host_id = ?', user_id, 3, user_id) }
  scope :order_by_created_at_desc, -> { order('created_at desc') }
  scope :new_requests, -> user_id { where(host_id: user_id, progress: 'requested') }
  scope :accepts, -> { where(progress: 3) }
  scope :for_dashboard, -> { where('progress = ? or progress = ?', 3, 6) }
  scope :finished_before_yesterday, -> { where("schedule_end <= ?", Time.zone.yesterday.in_time_zone('UTC')) }
  scope :not_finished, -> { where('schedule >= ?', Time.zone.tomorrow.beginning_of_day.in_time_zone('UTC') ) }
  scope :review_mail_never_be_sent, -> { where(review_mail_sent_at: nil) }
  scope :reviewed, -> { where.not(reviewed_at: nil) }
  scope :review_reply_mail_never_be_sent, -> { where(reply_mail_sent_at: nil) }
  scope :review_open?, -> { where(arel_table[:review_opened_at].not_eq(nil)) }
  scope :review_not_opened_yet, -> { where(arel_table[:review_opened_at].eq(nil)) }
  scope :review_expiration_date_is_before_yesterday, -> { where("schedule_end <= ?", Time.zone.yesterday.in_time_zone('UTC') - Settings.review.expiration_date.day) }
  scope :week_before, -> { where('schedule >= ? AND schedule <= ?', (Time.zone.today + 7.day).beginning_of_day.in_time_zone('UTC'), (Time.zone.today + 7.day).end_of_day.in_time_zone('UTC')) }
  scope :day_before, -> { where('schedule >= ? AND schedule <= ?', Time.zone.tomorrow.beginning_of_day.in_time_zone('UTC'),Time.zone.tomorrow.end_of_day.in_time_zone('UTC') ) }

  REGISTRABLE_ATTRIBUTES = %i(
    schedule_date schedule_hour schedule_minute
  )
  integrate_datetime_fields :schedule

  def continued?
    if self.requested? || self.under_construction?
      return true
    else
      false
    end
  end

  def string_of_progress
    return "承認依頼中" if self.requested?
    return "キャンセル" if self.canceled?
    return "キャンセル" if self.canceled_after_accepted?
    return "調整中" if self.under_construction?
    return "ツアー決定" if self.accepted?
    return "取り消し" if self.rejected?
    return "終了" if self.listing_closed?
  end

  def string_of_progress_english
    return Settings.reservation.progress.requested if self.requested?
    return Settings.reservation.progress.canceled if self.canceled?
    return Settings.reservation.progress.canceled_after_accepted if self.canceled_after_accepted?
    return Settings.reservation.progress.under_construction if self.under_construction?
    return Settings.reservation.progress.accepted if self.accepted?
    return Settings.reservation.progress.rejected if self.rejected?
    return Settings.reservation.progress.listing_closed if self.listing_closed?
  end

  def subject_of_update_mail
    return Settings.mailer.update_reservation.subject.canceled if self.canceled?
    return Settings.mailer.update_reservation.subject.canceled if self.canceled_after_accepted?
    return Settings.mailer.update_reservation.subject.under_construction if self.under_construction?
    return Settings.mailer.update_reservation.subject.accepted if self.accepted?
    return Settings.mailer.update_reservation.subject.rejected if self.rejected?
  end

  def body_of_update_mail
    return Settings.mailer.update_reservation.body.canceled if self.canceled?
    return Settings.mailer.update_reservation.body.canceled if self.canceled_after_accepted?
    return Settings.mailer.update_reservation.body.under_construction if self.under_construction?
    return Settings.mailer.update_reservation.body.accepted if self.accepted?
    return Settings.mailer.update_reservation.body.rejected if self.rejected?
  end
  
  def pair_guide_status_string
    return Settings.reservation.pair_guide_status.pg_under_construction if self.pg_under_construction?
    return Settings.reservation.pair_guide_status.pg_offering if self.pg_offering?
    return Settings.reservation.pair_guide_status.pg_completion if self.pg_completion?
  end

  def save_review_landed_at_now
    self.review_landed_at = Time.zone.now
    self.save
  end

  def save_reply_landed_at_now
    self.reply_landed_at = Time.zone.now
    self.save
  end

  def save_reviewed_at_now
    self.reviewed_at = Time.zone.now
    self.save
  end

  def save_replied_at_now
    self.replied_at = Time.zone.now
    self.save
  end

  def save_reply_mail_sent_at_now
    self.reply_mail_sent_at = Time.zone.now
    self.save
  end

  def save_review_opened_at_now
    self.review_opened_at = Time.zone.now
    self.save
  end

  def self.active_reservation(guest_id, host_id)
    reservation = self.latest_reservation(guest_id, host_id)
    if reservation.present? and not reservation.canceled? and not reservation.canceled_after_accepted? and not reservation.accepted?
      reservation.schedule_end.present? ? reservation.schedule_end > Time.zone.today : false
    else
      false
    end
  end

  def self.latest_reservation(guest_id, host_id)
    self.where(guest_id: guest_id, host_id: host_id).order('created_at desc').first
  end

  def amount
    #result = basic_amount < 2000 ? (basic_amount + 500).ceil : (basic_amount * 1.145).ceil
    result = (basic_amount * 1.145).ceil + self.insurance_fee
  end

  def amount_for_campaign
    #result = basic_amount < 2000 ? (basic_amount + 500).ceil : (basic_amount * 1.145).ceil
    result = self.amount
    result = result - self.campaign.discount if self.campaign.present?
    result = 0 if result < 0
    result
  end

  def basic_amount
    #total = self.price + self.price_for_support + self.price_for_both_guides
    total = self.price + self.price_for_support
    total + option_amount
  end

  def option_amount
    total = 0
    #if self.space_option
    #  self.space_options.each do |option|
    #    total += self[option]
    #  end
    #end

    if self.car_option
      self.car_options.each do |option|
        total += self[option]
      end
    end

    if self.bicycle_option
      bicycle_per = self.bicycle_rental
      total += bicycle_per * self.num_of_people
    end

    if self.other_option
      self.other_options.each do |option|
        total += self[option]
      end
    end
    total
  end

  def guide_price
    #self.price + self.price_for_support + self.price_for_both_guides
    self.price + self.price_for_support
  end

  def service_fee
    #basic_amount < 2000 ? 500 : (basic_amount * 0.145).ceil
    (basic_amount * 0.145).ceil
  end

  def paypal_amount
    result = self.basic_amount + handling_cost + self.insurance_fee
    result = result - self.campaign.discount if self.campaign.present?
    return result * 100
  end

  def paypal_sub_total
    self.basic_amount * 100
  end

  def handling_cost
    #basic_amount < 2000 ? 500 : (basic_amount * 0.145).ceil
    (basic_amount * 0.145).ceil
  end

  def paypal_handling_cost
    #basic_amount < 2000 ? 50000 : (basic_amount * 0.145).ceil * 100
    (basic_amount * 0.145).ceil * 100
  end
  
  def paypal_travel_insurance
    self.insurance_fee * 100
  end

  def paypal_campaign_discount
    0 - self.campaign.discount * 100
  end

  def cancellation_fee_for_dashboard
    if self.before_weeks? or self.amount_for_campaign <= 0
      0
    elsif self.before_days?
      self.amount_for_campaign - (self.amount_for_campaign / 2)
    else
      self.amount_for_campaign
    end
  end

  def cancellation_fee
    if self.refund_rate == 100 or self.amount_for_campaign <= 0
      0
    elsif self.refund_rate > 0
      self.amount_for_campaign - (self.amount_for_campaign / (100 / self.refund_rate))
    else
      self.amount_for_campaign
    end
  end

  #display cancel button or not
  def completed?
    if self.schedule.present?
      self.accepted? and self.schedule.to_date > Time.zone.today
    else
      false
    end
  end

  #finished tour or not
  def finished?
    if self.schedule_end.present?
      self.accepted? and self.schedule_end < Time.zone.today
    else
      false
    end
  end

  def review_for_guide_enabled?
    self.finished? and self.schedule_end + Settings.review.expiration_date.day >= Time.zone.today and self.reviewed_at.blank?
  end

  def review_for_guest_enabled?
    self.finished? and self.schedule_end + Settings.review.expiration_date.day >= Time.zone.today and self.replied_at.blank?
  end

  def set_price
    self.price = 0 if self.price.blank?
    self.price_for_support = 0 if self.price_for_support.blank?
    self.price_for_both_guides = 0 if self.price_for_both_guides.blank?

    self.space_options.each do |option|
      self[option] = 0 if self[option].blank?
    end

    self.car_options.each do |option|
      self[option] = 0 if self[option].blank?
    end

    self.guests_cost = 0 if self.guests_cost.blank?
    
    if !self.accepted? and !self.canceled_after_accepted?
      if self.basic_amount > 0
        self.insurance_fee = self.num_of_people * Settings.reservation.insurance_fee
      else
        self.insurance_fee = 0
      end
    end
    self
  end

  def space_options
    ['space_rental']
  end

  def car_options
    ['car_rental', 'gas', 'highway', 'parking']
  end

  def bicycle_options
    ['bicycle_rental']
  end

  def other_options
    ['other_cost']
  end

  def before_weeks?
    self.schedule.to_date >= Time.zone.today + 14.day
  end

  def before_days?
    self.schedule.to_date >= Time.zone.today + 3.day
  end

  def less_than_days?
    self.schedule.to_date < Time.zone.today + 3.day
  end

  def progress_is_not_under_construction?
    !self.under_construction?
  end

  def set_details(details)
    payment = self.payment.present? ? self.payment : Payment.create(reservation_id: self.id)
    payment.update(
        token: details.token,
        payer_id: details.payer_id,
        payers_status: details.params['payer_status'],
        amount: details.params['order_total'],
        currency_code: details.params['order_total_currency_id'],
        email: details.params['payer'],
        first_name: details.params['first_name'],
        last_name: details.params['last_name'],
        country_code: details.params['country'],
        status: 'confirmed'
      )
    payment
  end

  def set_purchase(response)
    self.payment.update(
      transaction_id: response.params['transaction_id'],
      transaction_date: response.params['payment_date'],
      status: 'completed')
  end

  def set_refund(response=nil, current_user)
    self.payment.update(
      transaction_id: response.params['refund_transaction_id'],
      refund_date: response.params['timestamp'],
      status: 'refunded') if response.present?
    set_cancel_by(current_user)
  end

  def set_cancel_by(current_user)
    #default: 0, guide: 1, guest_before_weeks: 2, guest_before_days: 3, guest_less_than_days: 4
    self.canceled_after_accepted!
    if self.host_id == current_user.id
      self.update(cancel_by: 'guide', refund_rate: Settings.payment.refunds.guide_cancel)
    elsif self.before_weeks?
      self.update(cancel_by: 'guest_before_weeks', refund_rate: Settings.payment.refunds.before_weeks_rate)
    elsif self.before_days?
      self.update(cancel_by: 'guest_before_days', refund_rate: Settings.payment.refunds.before_days_rate)
    else
      self.guest_less_than_days!
    end
  end

  def self.for_message_thread(guest_id, host_id)
    reservation = self.latest_reservation(guest_id, host_id)
    if reservation.present?
      if reservation.accepted?
        self.new(progress: 'accepted')
      elsif reservation.canceled_after_accepted?
        self.new(reservation.attributes)
      else
        reservation
      end
    else
      self.new(progress: '', car_option: false)
    end
  end
  
  def insurance_people_str
    people = 'peoples'
    people = 'people' if self.num_of_people == 1
    self.num_of_people.to_s + people
  end
  
  def host_profile_id
    profile = Profile.where(user_id: self.host_id).first
    profile.id if profile.present?
  end
  
  def guest_profile_id
    profile = Profile.where(user_id: self.guest_id).first
    profile.id if profile.present?
  end
  
  def pair_guide_profile_id
    profile = Profile.where(user_id: self.pair_guide_id).first
    profile.id if profile.present?
  end
  
  def review_writed?(user_id)
    ReviewForGuest.exists?(reservation_id: self.id, host_id: user_id)
  end
  
  def create_pair_guide_review
    main_review = ReviewForGuide.where(reservation_id: self.id, host_id: self.host_id).first
    pair_guide_review = main_review.dup
    pair_guide_review.host_id = self.pair_guide_id
    if pair_guide_review.save
      pair_guide_review.re_calc_ave_of_profile
    end
  end
end
