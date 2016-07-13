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
  
  mount_uploader :video, ProfileVideoUploader

  validates :user_id, presence: true
  validates :profile_id, presence: true
  validates :video, presence: true
  validates_each :video do |record, attr, value|
    if value.present? and value.file.size.to_f > UPLOAD_VIDEO_LIMIT_SIZE.megabytes.to_f
      #record.errors.add(attr, "You cannot upload a file greater than #{UPLOAD_VIDEO_LIMIT_SIZE}MB")
      record.errors.add(attr, I18n.t('errors.messages.size_over',size: UPLOAD_VIDEO_LIMIT_SIZE))
    end
  end
  UPLOAD_VIDEO_LIMIT_SIZE = ENV["UPLOAD_VIDEO_LIMIT_SIZE"].to_i.freeze
  
  #validates :order_num, numericality: {
  #  only_integer: true,
  #  equal_to: 0 # set has_one association
  #}
end
