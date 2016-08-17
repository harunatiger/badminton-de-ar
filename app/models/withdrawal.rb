# == Schema Information
#
# Table name: withdrawals
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  amount       :integer          default(0), not null
#  requested_at :datetime
#  paid_at      :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_withdrawals_on_paid_at       (paid_at)
#  index_withdrawals_on_requested_at  (requested_at)
#  index_withdrawals_on_user_id       (user_id)
#

class Withdrawal < ActiveRecord::Base
  belongs_to :user
  has_many :reservation_withdrawals, dependent: :destroy
  has_many :reservations, through: :reservation_withdrawals
  
  validates :user_id, presence: true
  validates :amount, presence: true
  validate :only_one_credit_can_exist, if: :credit?, on: :create
  
  scope :credit, -> { where(requested_at: nil, paid_at: nil) }
  scope :requests, -> { where.not(requested_at: nil).where(paid_at: nil) }
  scope :histories, -> { where.not(requested_at: nil, paid_at: nil) }
  scope :paid_in_two_weeks, -> { where('paid_at >= ?', (Time.zone.today - 14.day).beginning_of_day.in_time_zone('UTC')) }
  scope :order_by_created_at_desc, -> { order('created_at desc') }
  scope :order_by_updated_at_desc, -> { order('updated_at desc') }
  scope :order_by_requested_at_desc, -> { order('requested_at desc') }
  scope :order_by_paid_at_desc, -> { order('paid_at desc') }
  
  def credit?
    self.requested_at.blank? and self.paid_at.blank?
  end
  
  def request?
    self.requested_at.present? and self.paid_at.blank?
  end
  
  def paid?
    self.requested_at.present? and self.paid_at.present?
  end
  
  def only_one_credit_can_exist
    if Withdrawal.where(user_id: self.user_id).credit.present?
      errors.add(:user_id, :duplicate)
    end
  end
end
