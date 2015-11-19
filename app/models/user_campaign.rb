# == Schema Information
#
# Table name: user_campaigns
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  campaign_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_user_campaigns_on_campaign_id  (campaign_id)
#  index_user_campaigns_on_user_id      (user_id)
#

class UserCampaign < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign
end
