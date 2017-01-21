# == Schema Information
#
# Table name: counts
#
#  id         :integer          not null, primary key
#  player_id  :integer
#  count      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Count < ActiveRecord::Base
end
