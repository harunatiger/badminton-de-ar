# == Schema Information
#
# Table name: pre_mails
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_pre_mails_on_user_id  (user_id)
#

class PreMail < ActiveRecord::Base
  belongs_to :user
end
