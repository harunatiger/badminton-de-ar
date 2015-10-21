# == Schema Information
#
# Table name: profile_languages
#
#  id          :integer          not null, primary key
#  profile_id  :integer
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_profile_languages_on_language_id  (language_id)
#  index_profile_languages_on_profile_id   (profile_id)
#

class ProfileLanguage < ActiveRecord::Base
  belongs_to :profile
  belongs_to :language
end
