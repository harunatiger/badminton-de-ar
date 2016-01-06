# == Schema Information
#
# Table name: favorite_users
#
#  id           :integer          not null, primary key
#  from_user_id :integer          not null
#  to_user_id   :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_favorite_users_on_from_user_id  (from_user_id)
#  index_favorite_users_on_to_user_id    (to_user_id)
#

class FavoriteUser < ActiveRecord::Base
  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user, class_name: 'User'

  validates :from_user_id, presence: true
  validates :to_user_id, presence: true

end
