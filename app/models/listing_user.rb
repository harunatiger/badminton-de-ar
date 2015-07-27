# == Schema Information
#
# Table name: listing_users
#
#  id         :integer          not null, primary key
#  listing_id :integer          not null
#  host_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_listing_users_on_host_id     (host_id)
#  index_listing_users_on_listing_id  (listing_id)
#

class ListingUser < ActiveRecord::Base
  belongs_to :listing
  belongs_to :user, class_name: 'User', foreign_key: 'host_id'
end
