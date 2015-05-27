# == Schema Information
#
# Table name: wishlists
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string
#  range      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_wishlists_on_user_id           (user_id)
#  index_wishlists_on_user_id_and_name  (user_id,name) UNIQUE
#

class Wishlist < ActiveRecord::Base
  belongs_to :user, counter_cache: :wishlist_count
  has_many :favorites, dependent: :destroy

  validates :user_id, presence: true
  validates :name, presence: true

  scope :mine, -> user_id { where(user_id: user_id) }
  scope :order_by_created_at_desc, -> { order('created_at desc') }
end
