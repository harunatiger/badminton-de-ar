# == Schema Information
#
# Table name: profile_identities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  profile_id :integer
#  image      :string           default(""), not null
#  caption    :string           default("")
#  authorized :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer
#
# Indexes
#
#  index_profile_identities_on_profile_id  (profile_id)
#  index_profile_identities_on_user_id     (user_id)
#

class ProfileIdentity < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile

  mount_uploader :image, DefaultImageUploader

  validates :user_id, presence: true
  validates :profile_id, presence: true
  validates :image, presence: true
  validates :profile_id, uniqueness: true
  
  enum status: { uploaded: 0, authorized: 1, holded: 2, unauthorized: 3}

  scope :mine, -> user_id { where( user_id: user_id ) }

end
