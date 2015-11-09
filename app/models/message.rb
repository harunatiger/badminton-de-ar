# == Schema Information
#
# Table name: messages
#
#  id                 :integer          not null, primary key
#  message_thread_id  :integer          not null
#  from_user_id       :integer          not null
#  to_user_id         :integer          not null
#  content            :text             default(""), not null
#  read               :boolean          default(FALSE)
#  read_at            :datetime
#  listing_id         :integer          default(0), not null
#  reservation_id     :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  attached_file      :string
#  attached_extension :string
#  attached_name      :string
#
# Indexes
#
#  index_messages_on_from_user_id       (from_user_id)
#  index_messages_on_listing_id         (listing_id)
#  index_messages_on_message_thread_id  (message_thread_id)
#  index_messages_on_reservation_id     (reservation_id)
#  index_messages_on_to_user_id         (to_user_id)
#

class Message < ActiveRecord::Base
  belongs_to :message_thread, touch: true
  belongs_to :user, class_name: 'User', foreign_key: 'to_user_id'
  belongs_to :user, class_name: 'User', foreign_key: 'from_user_id'

  validates :message_thread_id, presence: true
  validates :from_user_id, presence: true
  validates :to_user_id, presence: true
  validates :content, presence: true, if: 'attached_file.blank?'
  validates :attached_file, presence: true, if: 'content.blank?'
  validates :attached_name, presence: true, if: 'attached_file.present?'
  validates :attached_extension, presence: true, if: 'attached_file.present?'

  mount_uploader :attached_file, MessageUploader

  scope :unread_messages, -> user_id { where(to_user_id: user_id, read: false) }
  scope :message_thread, -> message_thread_id { where(message_thread_id: message_thread_id) }
  scope :order_by_created_at_desc, -> { order('created_at desc') }
  scope :reservation, -> reservation_id { where(reservation_id: reservation_id) }
  
  def self.send_message(mt_obj, message_params)
    content = message_params['content'].present? ? message_params['content'] : ''
    attached_file =  message_params['attached_file'].present? ? message_params['attached_file'] : ''
    progress = message_params['progress'].present? ? message_params['progress'] : ''
    listing_id = message_params['listing_id'].present? ? message_params['listing_id'] : 0
    reservation_id = message_params['reservation_id'].present? ? message_params['reservation_id'] : 0 
    obj = Message.new(
      message_thread_id: mt_obj.id,
      content: content,
      attached_file: attached_file,
      read: false,
      from_user_id: message_params['from_user_id'],
      to_user_id: message_params['to_user_id'],
      listing_id: listing_id,
      reservation_id: reservation_id
    )
    
    obj.save
  end

  def self.make_all_read(message_thread_id, to_user_id)
    Message.where(message_thread_id: message_thread_id, to_user_id: to_user_id, read: false).update_all(read: true, read_at: Time.zone.now)
  end
  
  def host_id
    listing = Listing.find(self.listing_id)
    listing.user_id
  end
  
  def guest_id
    listing = Listing.find(self.listing_id)
    host_id = listing.user_id
    self.to_user_id == host_id ? self.from_user_id : self.to_user_id
  end


end
