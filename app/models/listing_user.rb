# == Schema Information
#
# Table name: listing_users
#
#  id              :integer          not null, primary key
#  listing_id      :integer
#  user_id         :integer
#  user_status     :integer
#  request_message :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_listing_users_on_listing_id  (listing_id)
#  index_listing_users_on_user_id     (user_id)
#

class ListingUser < ActiveRecord::Base
  belongs_to :listing
  belongs_to :user
  
  validates :user_id, presence: true
  validates :listing_id, presence: true
  validates :user_status, presence: true
  validates :user_id, :uniqueness => {:scope => :listing_id}
  
  enum user_status: { pending: 0, member: 1, receptionist: 2}
  
  scope :mine, -> user_id { where(user_id: user_id) }
  scope :opened, -> { joins(:listing).merge(Listing.opened) }
  scope :pending_members, -> listing_id { pending.where(listing_id: listing_id) }
  scope :receptionist_members, -> listing_id { receptionist.where(listing_id: listing_id) }
  scope :members, -> listing_id { member.where(listing_id: listing_id) }
  scope :accepted_members, -> listing_id { where.not(user_status: 0).where(listing_id: listing_id) }

  def self.is_receptionist?(user_id, listing_id)
    ListingUser.where(listing_id: listing_id, user_id: user_id).receptionist.present?
  end
end
