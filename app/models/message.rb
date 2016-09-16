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
#  friends_request    :boolean          default(FALSE)
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
  belongs_to :reservation

  validates :message_thread_id, presence: true
  validates :from_user_id, presence: true
  validates :to_user_id, presence: true
  validate :content_or_file_needed
  #validates :content, presence: true, if: 'attached_file.blank?'
  #validates :attached_file, presence: true, if: 'content.blank?'
  validates :attached_name, presence: true, if: 'attached_file.present?'
  validates :attached_extension, presence: true, if: 'attached_file.present?'
  validate :file_size_validation, if: 'attached_file.present?'

  mount_uploader :attached_file, MessageUploader

  scope :unread_messages, -> user_id { where(to_user_id: user_id, read: false) }
  scope :message_thread, -> message_thread_id { where(message_thread_id: message_thread_id) }
  scope :order_by_created_at_desc, -> { order('created_at desc') }
  scope :order_by_created_at_asc, -> { order('created_at asc') }
  scope :reservation, -> reservation_id { where(reservation_id: reservation_id) }
  
  def content_or_file_needed
    if self.content.blank? and self.attached_file.blank?
      errors[:base] << Settings.message.save.failure
    end
  end

  def self.send_message(mt_obj, message_params)
    content = message_params['content'].present? ? message_params['content'] : ''
    attached_file =  message_params['attached_file'].present? ? message_params['attached_file'] : ''
    progress = message_params['progress'].present? ? message_params['progress'] : ''
    listing_id = message_params['listing_id'].present? ? message_params['listing_id'] : 0
    reservation_id = message_params['reservation_id'].present? ? message_params['reservation_id'] : 0
    
    ActiveRecord::Base.transaction do
      if attached_file.present?
        
        if content.present?
          @obj = Message.new(
            message_thread_id: mt_obj.id,
            content: content,
            attached_file: '',
            read: false,
            from_user_id: message_params['from_user_id'],
            to_user_id: message_params['to_user_id'],
            listing_id: listing_id,
            reservation_id: reservation_id
          )
          @obj.save!
        end
        
        attached_file.each_with_index do |file, index|
          @obj = Message.new(
            message_thread_id: mt_obj.id,
            content: '',
            attached_file: file,
            read: false,
            from_user_id: message_params['from_user_id'],
            to_user_id: message_params['to_user_id'],
            listing_id: listing_id,
            reservation_id: reservation_id
          )
          @obj.save!
        end
        
      else
        @obj = Message.new(
          message_thread_id: mt_obj.id,
          content: content,
          attached_file: '',
          read: false,
          from_user_id: message_params['from_user_id'],
          to_user_id: message_params['to_user_id'],
          listing_id: listing_id,
          reservation_id: reservation_id
        )
        @obj.save!
      end
    end
    return true
    rescue => e
    return @obj
  end
  
  # use when create reservation
  def self.send_request_message(reservation)
    if reservation.message_thread_id
      mt_obj = GuestThread.find(reservation.message_thread_id)
    else
      if id = GuestThread.exists_thread?(reservation.host_id, reservation.guest_id)
        mt_obj = GuestThread.find(id)
      else
        mt_obj = GuestThread.create_thread(reservation.host_id, reservation.guest_id)
      end
    end
    
    Message.create(
      message_thread_id: mt_obj.id,
      content: Settings.reservation.msg.reserve,
      read: false,
      from_user_id: reservation.guest_id,
      to_user_id: reservation.host_id,
      listing_id: reservation.try(:listing_id) || 0,
      reservation_id: reservation.id
    )
  end
  
  # use when send pair guide request
  def self.send_firends_message(to_user_id, from_user_id, content, message_thread_id, msg=nil)
    unless message_thread_id.present?
      if mt = GuideThread.exists_thread_for_pair_request?(to_user_id, from_user_id)
        mt_obj = mt
      else
        mt_obj = GuideThread.create_thread(to_user_id, from_user_id)
      end
    else
      mt_obj = GuideThread.find(message_thread_id)
    end
    
    if msg.present?
      Message.create(
        message_thread_id: mt_obj.id,
        content: msg,
        read: false,
        from_user_id: from_user_id,
        to_user_id: to_user_id,
        friends_request: true
      )
    else
      Message.create(
        message_thread_id: mt_obj.id,
        content: content,
        read: false,
        from_user_id: from_user_id,
        to_user_id: to_user_id
      )
    end
  end
  
  def self.send_reservation_message_to_host(reservation, content, reply_from_host=nil)
    mt_obj = GuestThread.find(reservation.message_thread_id)
    mt_obj.update(reply_from_host: reply_from_host, first_message: false) if reply_from_host.present?
    Message.create(
      message_thread_id: mt_obj.id,
      content: content,
      read: false,
      from_user_id: reservation.guest_id,
      to_user_id: reservation.host_id,
      listing_id: reservation.try(:listing_id) || 0,
      reservation_id: reservation.id
    )
  end
  
  def self.send_reservation_message_to_guest(reservation, content)
    mt_obj = GuestThread.find(reservation.message_thread_id)
    mt_obj.update(reply_from_host: true, first_message: false)
    Message.create(
      message_thread_id: mt_obj.id,
      content: content,
      read: false,
      from_user_id: reservation.host_id,
      to_user_id: reservation.guest_id,
      listing_id: reservation.try(:listing_id) || 0,
      reservation_id: reservation.id
    )
  end
  
  def self.send_message_to_selected_guides(reservation, to_user_id)
    unless mt_obj = PairGuideThread.existed_pair_guide_thread(reservation.id, to_user_id)
      mt_obj = PairGuideThread.create_thread(to_user_id, reservation.host_id, reservation.id)
    end
    Message.create(
      message_thread_id: mt_obj.id,
      content: Settings.reservation.msg.send_message,
      read: false,
      from_user_id: reservation.host_id,
      to_user_id: to_user_id
    )
  end
  
  def self.send_pair_guide_message(message_thread_id, content, from_user_id, to_user_id)
    mt_obj = PairGuideThread.find(message_thread_id)
    Message.create(
      message_thread_id: mt_obj.id,
      content: content,
      read: false,
      from_user_id: from_user_id,
      to_user_id: to_user_id
    )
  end
  
  def self.send_what_talk_about(message_thread, guest_id, content)
    host_id = message_thread.counterpart_user(guest_id).try('id')
    to_guest_message = Message.new(
      message_thread_id: message_thread.id,
      content: Settings.message.what_talk_about.to_guest,
      read: false,
      from_user_id: host_id,
      to_user_id: guest_id
    )
    
    message = content == 'Others' ? Settings.message.what_talk_about.to_guide_other : Settings.message.what_talk_about.to_guide + content.downcase!
    to_guide_message = Message.new(
      message_thread_id: message_thread.id,
      content: message + '.',
      read: false,
      from_user_id: guest_id,
      to_user_id: host_id
    )
    
    if to_guest_message.valid? and to_guide_message.valid?
      to_guest_message.save
      to_guide_message.save
      message_params = {
        'from_user_id' => guest_id,
        'to_user_id' => host_id,
        'content' => to_guide_message.content
        }
      return message_params
    else
      return false
    end
  end

  def english_content
    if self.try('content') == Settings.reservation.msg.request
      Settings.reservation.msg.request_en
    elsif self.try('content') == Settings.reservation.msg.accepted
      Settings.reservation.msg.accepted_en
    elsif self.try('content') == Settings.reservation.msg.canceled
      Settings.reservation.msg.canceled_en
    elsif self.try('content') == Settings.reservation.msg.reserve
      Settings.reservation.msg.reserve_en
    elsif self.friends_request
      Settings.friend.msg.request
    else
      self.try('content')
    end
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

  def file_size_validation
    extn = self.attached_extension
    size = self.attached_file.size
    if extn.include?("pdf")
      errors.add(:attached_file, Settings.message.save.toobig) if size > 5.megabytes
    else
      errors.add(:attached_file, Settings.message.save.toobig) if size > 3.megabytes
    end
  end

  def self.time_ago(message)
    now = Time.zone.now
    updated = message.updated_at
    second = (now - updated).to_i
  end

end
