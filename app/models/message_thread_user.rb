# == Schema Information
#
# Table name: message_thread_users
#
#  id                :integer          not null, primary key
#  message_thread_id :integer          not null
#  user_id           :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_message_thread_users_on_message_thread_id              (message_thread_id)
#  index_message_thread_users_on_message_thread_id_and_user_id  (message_thread_id,user_id) UNIQUE
#  index_message_thread_users_on_user_id                        (user_id)
#

class MessageThreadUser < ActiveRecord::Base
  belongs_to :message_thread
  belongs_to :user

  #validates :message_thread_id, presence: true
  validates :user_id, presence: true

  scope :user_joins, -> user_id { where(user_id: user_id) }
  scope :mine, -> user_id { where(user_id: user_id) }
  scope :order_by_updated_at_desc, -> { order('updated_at desc') }
  scope :order_by_updated_at_asc, -> { order('updated_at asc') }
  scope :order_by_created_at_asc, -> { order('created_at asc') }
  scope :message_thread, -> message_thread_id { where( message_thread_id: message_thread_id ) }

  def self.is_a_member(message_thread_id, user_id)
    MessageThreadUser.exists?(message_thread_id: message_thread_id, user_id: user_id)
  end
end
