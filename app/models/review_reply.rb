# == Schema Information
#
# Table name: review_replies
#
#  id               :integer          not null, primary key
#  review_id        :integer
#  msg              :text             default("")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  accuracy         :integer          default(0)
#  communication    :integer          default(0)
#  clearliness      :integer          default(0)
#  location         :integer          default(0)
#  check_in         :integer          default(0)
#  cost_performance :integer          default(0)
#  total            :integer          default(0)
#
# Indexes
#
#  index_review_replies_on_review_id  (review_id)
#

class ReviewReply < ActiveRecord::Base
  belongs_to :review

  #validates :review_id, presence: true
  validates :msg, presence: true
  
  def self.mine_as_guest(user_id)
    reviews = Review.i_do(user_id).joins(:reservation).merge(Reservation.review_open?).order_by_updated_at_desc
    reviews.map{|r| r.review_reply} if reviews.present?
  end
end
