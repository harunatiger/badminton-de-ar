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
  
  scope :mine, -> user_id { where( user_id: user_id ) }

  after_save :set_percentage

  def set_percentage
<<<<<<< HEAD
  	Profile.set_percentage(self.user_id)
=======
  	Profile.set_percentage(self.profile_id)
>>>>>>> 29c14722e9248496f2fcc2b4110a43862a1c7452
  end
end
