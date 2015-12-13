# == Schema Information
#
# Table name: reservations
#
#  id                      :integer          not null, primary key
#  host_id                 :integer
#  guest_id                :integer
#  listing_id              :integer
#  schedule                :datetime         not null
#  num_of_people           :integer          default(0), not null
#  msg                     :text             default("")
#  progress                :integer          default(0), not null
#  reason                  :text             default("")
#  review_mail_sent_at     :datetime
#  review_expiration_date  :datetime
#  review_landed_at        :datetime
#  reviewed_at             :datetime
#  reply_mail_sent_at      :datetime
#  reply_landed_at         :datetime
#  replied_at              :datetime
#  review_opened_at        :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  time_required           :decimal(9, 6)    default(0.0)
#  price                   :integer          default(0)
#  option_price            :integer          default(0)
#  place                   :string           default("")
#  description             :text             default("")
#  schedule_end            :date
#  option_price_per_person :integer          default(0)
#  place_memo              :text             default("")
#  campaign_id             :integer
#  price_other             :integer          default(0)
#  refund_rate             :integer          default(0)
#
# Indexes
#
#  index_reservations_on_campaign_id  (campaign_id)
#  index_reservations_on_guest_id     (guest_id)
#  index_reservations_on_host_id      (host_id)
#  index_reservations_on_listing_id   (listing_id)
#

class Reservation < ActiveRecord::Base
  include DatetimeIntegratable
  before_save :set_price

  belongs_to :user, class_name: 'User', foreign_key: 'host_id'
  belongs_to :user, class_name: 'User', foreign_key: 'guest_id'
  belongs_to :listing
  belongs_to :campaign
  has_one :review
  has_one :payment
  has_many :ngevents, dependent: :destroy

  # Check config/settings.yml: Settings.reservation.progress
  enum progress: { requested: 0, canceled: 1, holded: 2, accepted: 3, rejected: 4, listing_closed: 5 }
  #enum progress: [requested, canceled, holded, accepted, rejected, listing_closed]

  attr_accessor :message_thread_id
  attr_accessor :campaign_code
  accepts_nested_attributes_for :payment

  validates :host_id, presence: true
  validates :guest_id, presence: true
  validates :listing_id, presence: true
  validates :schedule, presence: true
  validates :schedule_end, presence: true
  validates :num_of_people, presence: true
  validates :progress, presence: true
  #validates :price, presence: true

  scope :as_guest, -> user_id { where(guest_id: user_id) }
  scope :as_host, -> user_id { where(host_id: user_id) }
  scope :order_by_created_at_desc, -> { order('created_at desc') }
  scope :new_requests, -> user_id { where(host_id: user_id, progress: 'requested') }
  scope :accepts, -> { where(progress: 3) }
  scope :finished_before_yesterday, -> { where("schedule_end <= ?", Time.zone.yesterday.in_time_zone('UTC')) }
  scope :review_mail_never_be_sent, -> { where(review_mail_sent_at: nil) }
  scope :reviewed, -> { where.not(reviewed_at: nil) }
  scope :review_reply_mail_never_be_sent, -> { where(reply_mail_sent_at: nil) }
  scope :review_open?, -> { where(arel_table[:review_opened_at].not_eq(nil)) }
  scope :week_before, -> { where('schedule >= ? AND schedule <= ?', (Time.zone.today + 7.day).beginning_of_day.in_time_zone('UTC'), (Time.zone.today + 7.day).end_of_day.in_time_zone('UTC')) }
  scope :day_before, -> { where('schedule >= ? AND schedule <= ?', Time.zone.tomorrow.beginning_of_day.in_time_zone('UTC'),Time.zone.tomorrow.end_of_day.in_time_zone('UTC') ) }

  REGISTRABLE_ATTRIBUTES = %i(
    schedule_date schedule_hour schedule_minute
  )
  integrate_datetime_fields :schedule

  def continued?
    if self.requested? || self.holded?
      return true
    else
      false
    end
  end

  def string_of_progress
    return "承認依頼中" if self.requested?
    return "キャンセル" if self.canceled?
    return "調整中" if self.holded?
    return "ツアー決定" if self.accepted?
    return "取り消し" if self.rejected?
    return "終了" if self.listing_closed?
  end
  
  def string_of_progress_english
    return "Request" if self.requested?
    return "Cancel" if self.canceled?
    return "Under construction" if self.holded?
    return "Accept" if self.accepted?
    return "Delete" if self.rejected?
    return "Close" if self.listing_closed?
  end

  def string_of_progress_for_message_thread
    return Settings.reservation.progress_for_message_thread.requested if self.requested?
    return Settings.reservation.progress_for_message_thread.canceled if self.canceled?
    return Settings.reservation.progress_for_message_thread.accepted if self.accepted?
    return Settings.reservation.progress_for_message_thread.rejected if self.rejected?
  end

  def subject_of_update_mail
    return Settings.mailer.update_reservation.subject.canceled if self.canceled?
    return Settings.mailer.update_reservation.subject.holded if self.holded?
    return Settings.mailer.update_reservation.subject.accepted if self.accepted?
    return Settings.mailer.update_reservation.subject.rejected if self.rejected?
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
    if reservation.present? and not reservation.canceled? and not reservation.accepted?
      reservation.schedule_end.present? ? reservation.schedule_end > Time.zone.today : false
    else
      false
    end
  end

  def self.requested_reservation(guest_id, host_id)
    self.where(guest_id: guest_id, host_id: host_id, progress: 'requested').first
  end

  def self.latest_reservation(guest_id, host_id)
    self.where(guest_id: guest_id, host_id: host_id).order('created_at desc').first
  end

  def amount
    result = basic_amount < 2000 ? (basic_amount + 500).ceil : (basic_amount * 1.125).ceil
  end
  
  def amount_for_campaign
    result = basic_amount < 2000 ? (basic_amount + 500).ceil : (basic_amount * 1.125).ceil
    result = result - self.campaign.discount if self.campaign.present?
    result = 0 if result < 0
    result
  end
  
  def basic_amount
    self.price + self.price_other + self.option_price + (self.option_price_per_person * self.num_of_people)
  end
  
  def paypal_amount
    result = self.basic_amount + handling_cost
    result = result - self.campaign.discount if self.campaign.present?
    return result * 100
  end
  
  def paypal_sub_total
    self.basic_amount * 100
  end
  
  def handling_cost
    basic_amount < 2000 ? 500 : (basic_amount * 0.125).ceil
  end
  
  def paypal_handling_cost
    basic_amount < 2000 ? 50000 : (basic_amount * 0.125).ceil * 100
  end
  
  def paypal_campaign_discount
    0 - self.campaign.discount * 100
  end

  def completed?
    if self.schedule.present?
      self.accepted? and self.schedule.to_date > Time.zone.today
    else
      false
    end
  end
  
  def set_price
    self.price = 0 if self.price.blank?
    self.price_other = 0 if self.price_other.blank?
    self.option_price = 0 if self.option_price.blank?
    self.option_price_per_person = 0 if self.option_price_per_person.blank?
    self
  end
  
  def before_weeks?
    self.schedule.to_date >= Time.zone.today + 14.day
  end
  
  def before_days?
    self.schedule.to_date >= Time.zone.today + 3.day
  end

end
