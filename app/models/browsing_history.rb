# == Schema Information
#
# Table name: browsing_histories
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  listing_id :integer
#  viewed_at  :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_browsing_histories_on_listing_id  (listing_id)
#  index_browsing_histories_on_user_id     (user_id)
#  index_browsing_histories_on_viewed_at   (viewed_at)
#

class BrowsingHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :listing

  validates :user_id, presence: true
  validates :listing_id, presence: true
  
  scope :viewed_when, -> from, to { where('created_at >= ? AND created_at <= ?', from.in_time_zone('UTC'), to.in_time_zone('UTC')) }

  def self.insert_record(user_id, listing_id)
    BrowsingHistory.create(
      user_id: user_id,
      listing_id: listing_id,
      viewed_at: Time.zone.now.to_date
    )
  end
  
  def self.latest_listing_id(user)
    browsing_history = BrowsingHistory.where(user_id: user.id).order('created_at desc').first
    browsing_history.present? ? browsing_history.listing_id : false
  end
  
  def self.listings_pv(listings)
    self.where(listing_id: listings.ids)
  end
end
