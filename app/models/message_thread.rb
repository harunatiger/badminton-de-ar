# == Schema Information
#
# Table name: message_threads
#
#  id                :integer          not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  host_id           :integer
#  reply_from_host   :boolean          default(FALSE)
#  first_message     :boolean          default(TRUE)
#  noticemail_sended :boolean          default(FALSE)
#  type              :string
#
# Indexes
#
#  index_message_threads_on_host_id         (host_id)
#  index_message_threads_on_reservation_id  (reservation_id)
#

class MessageThread < ActiveRecord::Base
  has_many :messages, dependent: :destroy
  has_many :message_thread_users, dependent: :destroy
  has_many :users, through: :message_thread_users, dependent: :destroy

  attr_accessor :reservation_progress

  scope :order_by_updated_at_desc, -> { order('updated_at') }
  scope :typed, -> type { where(type: type)}
  
  def counterpart_user(my_user_id)
    self.users.where.not(id: my_user_id).first
  end

  def self.exists_thread?(to_user_id, from_user_id)
    t_threads = MessageThreadUser.user_joins(to_user_id).joins(:message_thread).merge(MessageThread.typed(self.model_name.name)).select(:message_thread_id)
    f_threads = MessageThreadUser.user_joins(from_user_id).joins(:message_thread).merge(MessageThread.typed(self.model_name.name)).select(:message_thread_id)
    tt_array = []
    ft_array = []
    t_threads.each do |tt|
      tt_array << tt.message_thread_id
    end
    f_threads.each do |ft|
      ft_array << ft.message_thread_id
    end
    MessageThread.common_threads(tt_array, ft_array, from_user_id)
  end

  def self.common_threads(a_array, b_array, from_user_id)
    result = a_array & b_array
    if result.size.zero?
      res = false
    else
      result.each do |id|
        if MessageThread.find(id).same_thread?(from_user_id)
          res = id
          break
        end
      end
    end
    res
  end

  def self.create_thread(to_user_id, from_user_id)
    mt = MessageThread.create(type: self.model_name.name)
    mt.update(host_id: to_user_id) if mt.guest_thread?
    #mt.update(main_guide_id: from_user_id) if mt.guide_thread?
    
    MessageThreadUser.create(
      message_thread_id: mt.id,
      user_id: to_user_id
    )
    MessageThreadUser.create(
      message_thread_id: mt.id,
      user_id: from_user_id
    )
    mt
  end

  def self.unread(user_id)
    mts = MessageThreadUser.where(user_id: user_id).joins(:message_thread).merge(MessageThread.typed(self.model_name.name))
    result_array = []
    mts.each do |mt|
      result_array << mt.id if Message.exists?(message_thread_id: mt.message_thread_id, to_user_id: user_id, read: false)
    end
    result_array
  end

  def self.unread_messages(user_id)
    mts = MessageThreadUser.where(user_id: user_id)
    result_array = []
    mts.each do |mt|
      msgs = Message.where(message_thread_id: mt.message_thread_id, to_user_id: user_id, read: false)
      msgs.each do |msg|
        result_array << msg if msg.present?
      end
    end
    result_array
  end

  def set_reservation_progress
    message = Message.message_thread(self.id).where.not(listing_id: 0).order('created_at desc').first
    reservation = Reservation.latest_reservation(message.try('guest_id'), message.try('host_id'))
    self.reservation_progress = reservation.try('string_of_progress_english') || ''
    self
  end

  def same_thread?(from_user_id)
    if self.origin_from_user_id
      self.origin_from_user_id == from_user_id
    else
      return self.host_id != from_user_id
    end
  end
  
  def guest_thread?
    self.type == 'GuestThread'
  end
  
  def guide_thread?
    self.type == 'GuideThread'
  end
  
  def origin_from_user_id
    message = Message.message_thread(self.id).order('created_at asc').first
    message.present? ? message.from_user_id : false
  end
  
  def origin_to_user_id
    message = Message.message_thread(self.id).order('created_at asc').first
    message.present? ? message.to_user_id : false
  end
end
