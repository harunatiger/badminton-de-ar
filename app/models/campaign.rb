# == Schema Information
#
# Table name: campaigns
#
#  id         :integer          not null, primary key
#  code       :string           not null
#  discount   :integer
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_campaigns_on_code      (code)
#  index_campaigns_on_discount  (discount)
#  index_campaigns_on_type      (type)
#

class Campaign < ActiveRecord::Base
  has_many :user_campaigns, dependent: :destroy
  has_many :users, :through => :user_campaigns, dependent: :destroy
  has_many :reservations, dependent: :destroy
  
  validates :code, :type, presence: true
  validates :code, uniqueness: true
  
  attr_accessor :used_count
  
  def self.remove_used_code(reservation)
    if reservation.campaign.present?
      user = User.find(reservation.guest_id)
      user.campaigns = user.campaigns.where.not(id: reservation.campaign_id)
    end
  end
end
