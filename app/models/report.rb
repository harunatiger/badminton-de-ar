# == Schema Information
#
# Table name: reports
#
#  id           :integer          not null, primary key
#  to_user_id   :integer
#  from_user_id :integer
#  user_type    :integer          default(0), not null
#  reason       :string           default("")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_reports_on_from_user_id  (from_user_id)
#  index_reports_on_to_user_id    (to_user_id)
#  index_reports_on_user_type     (user_type)
#

class Report < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: 'from_user_id'
  belongs_to :user, class_name: 'User', foreign_key: 'to_user_id'
  
  enum user_type: { nomal: 0, guest: 1, guide: 2}
  
  def save_user_type(message_thread)
    if message_thread.guide_thread? or message_thread.pair_guide_thread? or (message_thread.guest_thread? and message_thread.host_id == self.to_user_id)
      self.guide!
    else
      self.guest!
    end
  end
end
