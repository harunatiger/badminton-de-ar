# == Schema Information
#
# Table name: profile_pickups
#
#  id         :integer          not null, primary key
#  profile_id :integer
#  pickup_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_profile_pickups_on_pickup_id   (pickup_id)
#  index_profile_pickups_on_profile_id  (profile_id)
#

class ProfilePickup < ActiveRecord::Base
  acts_as_taggable
  belongs_to :profile
  belongs_to :pickup
  
  scope :order_by_created_at_asc, -> { order('created_at asc') }
  
  def tag_list_sort_by_created_at
    self.tags.order('created_at asc')
  end
end
