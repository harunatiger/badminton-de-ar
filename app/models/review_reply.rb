# == Schema Information
#
# Table name: review_replies
#
#  id         :integer          not null, primary key
#  review_id  :integer
#  msg        :text             default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_review_replies_on_review_id  (review_id)
#

class ReviewReply < ActiveRecord::Base
  belongs_to :review

  validates :review_id, presence: true
  validates :msg, presence: true
end
