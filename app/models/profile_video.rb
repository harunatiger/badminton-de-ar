# == Schema Information
#
# Table name: profile_videos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  profile_id :integer
#  video      :string           default(""), not null
#  caption    :string           default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_profile_videos_on_profile_id  (profile_id)
#  index_profile_videos_on_user_id     (user_id)
#

class ProfileVideo < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile

  validates :user_id, presence: true
  validates :profile_id, presence: true
  validates :video, presence: true
  #validates :order_num, numericality: {
  #  only_integer: true,
  #  equal_to: 0 # set has_one association
  #}
end
