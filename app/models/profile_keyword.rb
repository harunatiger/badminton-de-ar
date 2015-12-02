# == Schema Information
#
# Table name: profile_keywords
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  profile_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_profile_keywords_on_profile_id  (profile_id)
#  index_profile_keywords_on_user_id     (user_id)
#

class ProfileKeyword < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile
end
