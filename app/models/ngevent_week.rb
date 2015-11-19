# == Schema Information
#
# Table name: ngevent_weeks
#
#  id         :integer          not null, primary key
#  listing_id :integer          not null
#  dow        :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ngevent_weeks_on_dow         (dow)
#  index_ngevent_weeks_on_listing_id  (listing_id)
#

class NgeventWeek < ActiveRecord::Base
end
