# == Schema Information
#
# Table name: reservations
#
#  id                     :integer          not null, primary key
#  host_id                :integer
#  guest_id               :integer
#  listing_id             :integer
#  schedule               :datetime         not null
#  num_of_people          :integer          not null
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
#  time_required          :integer          default(1)
#  price                  :integer          default(0)
#  option_price           :integer          default(0)
#  place                  :string           default("")
#  description            :text             default("")
#
# Indexes
#
#  index_reservations_on_guest_id    (guest_id)
#  index_reservations_on_host_id     (host_id)
#  index_reservations_on_listing_id  (listing_id)
#

class Reservation < ActiveRecord::Base
  include DatetimeIntegratable

  belongs_to :user, class_name: 'User', foreign_key: 'host_id'
  belongs_to :user, class_name: 'User', foreign_key: 'guest_id'
  belongs_to :listing
  has_one :review
  has_one :payment
  has_many :ngevents, dependent: :destroy

  # Check config/settings.yml: Settings.reservation.progress
  enum progress: { requested: 0, canceled: 1, holded: 2, accepted: 3, rejected: 4, listing_closed: 5 }
  #enum progress: [requested, canceled, holded, accepted, rejected, listing_closed]

  attr_accessor :message_thread_id
  accepts_nested_attributes_for :payment

  validates :host_id, presence: true
  validates :guest_id, presence: true
  validates :listing_id, presence: true
  validates :schedule, presence: true
  validates :num_of_people, presence: true
  validates :progress, presence: true
  validates :price, presence: true

  scope :as_guest, -> user_id { where(guest_id: user_id) }
  scope :as_host, -> user_id { where(host_id: user_id) }
  scope :order_by_created_at_desc, -> { order('created_at desc') }
  scope :new_requests, -> user_id { where(host_id: user_id, progress: 'requested') }
  scope :accepts, -> { where(progress: 3) }
  scope :finished_before_yesterday, -> { where("schedule <= ?", Time.zone.yesterday) }
  scope :review_mail_never_be_sent, -> { where(review_mail_sent_at: nil) }
  scope :reviewed, -> { where.not(reviewed_at: nil) }
  scope :review_reply_mail_never_be_sent, -> { where(reply_mail_sent_at: nil) }
  scope :review_open?, -> { where(arel_table[:review_opened_at].not_eq(nil)) }

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
    return "保留" if self.holded?
    return "承認" if self.accepted?
    return "取り消し" if self.rejected?
    return "終了" if self.listing_closed?
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
    reservations = self.where(guest_id: guest_id, host_id: host_id)
    reservation = reservations.where(progress: 0).first
    reservation = reservations.where(progress: 3).order('created_at desc').first if reservation.blank?
    reservation = reservations.where(progress: 1).order('created_at desc').first if reservation.blank?
    reservation
  end
  
  def self.requested_reservation(guest_id, host_id)
    self.where(guest_id: guest_id, host_id: host_id, progress: 'requested').first
  end
  
  def self.latest_reservation(guest_id, host_id)
    self.where(guest_id: guest_id, host_id: host_id).order('created_at desc').first
  end
  
  def amount
    self.price + self.option_price
  end
  
  def paypal_amount
    self.amount * 100
  end
  
  def completed?
    self.accepted? and self.schedule > Date.today
  end
end
