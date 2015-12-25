# == Schema Information
#
# Table name: pre_mails
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email      :string           default("")
#  first_name :string           default("")
#  last_name  :string           default("")
#
# Indexes
#
#  index_pre_mails_on_user_id  (user_id)
#

class PreMail < ActiveRecord::Base
  belongs_to :user
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :email, uniqueness: true
end
