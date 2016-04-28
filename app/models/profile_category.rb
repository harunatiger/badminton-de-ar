# == Schema Information
#
# Table name: profile_categories
#
#  id          :integer          not null, primary key
#  profile_id  :integer
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_profile_categories_on_category_id  (category_id)
#  index_profile_categories_on_profile_id   (profile_id)
#

class ProfileCategory < ActiveRecord::Base
  acts_as_taggable
  belongs_to :profile
  belongs_to :category
  
  scope :order_by_created_at_asc, -> { order('created_at asc') }
end
