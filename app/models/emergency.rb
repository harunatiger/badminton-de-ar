# == Schema Information
#
# Table name: emergencies
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  profile_id   :integer
#  name         :string           not null
#  phone        :string
#  email        :string
#  relationship :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_emergencies_on_profile_id  (profile_id)
#  index_emergencies_on_user_id     (user_id)
#

class Emergency < ActiveRecord::Base
end
