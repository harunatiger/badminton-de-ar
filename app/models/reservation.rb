# == Schema Information
#
# Table name: reservations
#
#  id                     :integer          not null, primary key
#  host_id                :integer
#  guest_id               :integer
#  listing_id             :integer
#  schedule               :date             not null
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
#  express_token          :string           default("")
#  express_payer_id       :string           default("")
#
# Indexes
#
#  index_reservations_on_guest_id    (guest_id)
#  index_reservations_on_host_id     (host_id)
#  index_reservations_on_listing_id  (listing_id)
#

class Reservation < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: 'host_id'
  belongs_to :user, class_name: 'User', foreign_key: 'guest_id'
  belongs_to :listing
  has_one :review

  # Check config/settings.yml: Settings.reservation.progress
  enum progress: { requested: 0, canceled: 1, holded: 2, accepted: 3, rejected: 4, listing_closed: 5 }
  #enum progress: [requested, canceled, holded, accepted, rejected, listing_closed]

  validates :host_id, presence: true
  validates :guest_id, presence: true
  validates :listing_id, presence: true
  validates :schedule, presence: true
  validates :num_of_people, presence: true
  validates :progress, presence: true

  scope :as_guest, -> user_id { where(guest_id: user_id) }
  scope :as_host, -> user_id { where(host_id: user_id) }
  scope :order_by_created_at_desc, -> { order('created_at desc') }
  scope :new_requests, -> user_id { where(host_id: user_id, progress: 'requested') }
  scope :finished_before_yesterday, -> { where("schedule <= ?", Time.zone.yesterday) }
  scope :review_mail_never_be_sent, -> { where(review_mail_sent_at: nil) }
  scope :reviewed, -> { where.not(reviewed_at: nil) }
  scope :review_reply_mail_never_be_sent, -> { where(reply_mail_sent_at: nil) }
  scope :review_open?, -> { where(arel_table[:review_opened_at].not_eq(nil)) }

  def continued?
    if self.requested? || self.holded?
      return true
    else
      false
    end
  end

  def string_of_progress
    return "参加希望" if self.requested?
    return "キャンセル" if self.canceled?
    return "保留" if self.holded?
    return "承諾" if self.accepted?
    return "拒否" if self.rejected?
    return "非公開" if self.listing_closed?
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
end
