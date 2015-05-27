# == Schema Information
#
# Table name: auths
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  provider     :string
#  uid          :string
#  access_token :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_auths_on_user_id  (user_id)
#

class Auth < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :provider, presence: true
  validates :provider, inclusion: { in: %w(facebook) }
  validates :uid, presence: true
  validates :uid, uniqueness: true
  validates :access_token, presence: true
  validates :access_token, uniqueness: true
end
