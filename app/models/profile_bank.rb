# == Schema Information
#
# Table name: profile_banks
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  profile_id     :integer
#  name           :string
#  branch_name    :string
#  account_type   :integer
#  user_name      :string
#  number         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  paypal_account :string           default("")
#
# Indexes
#
#  index_profile_banks_on_profile_id  (profile_id)
#  index_profile_banks_on_user_id     (user_id)
#

class ProfileBank < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile
  
  #validates :name, presence: true
  #validates :branch_name, presence: true
  #validates :account_type, presence: true
  #validates :user_name, presence: true
  #validates :number, presence: true
  validates :profile_id, uniqueness: true
end
