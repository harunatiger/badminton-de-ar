# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  uid                    :string           default(""), not null
#  provider               :string           default(""), not null
#  username               :string
#  soft_destroyed_at      :datetime
#  email_before_closed    :string           default("")
#  reason                 :text             default("")
#  user_type              :integer          default(0)
#  last_access_date       :date
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :timeoutable
  include Payments
  soft_deletable
  has_friendship
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  has_many :auths, dependent: :destroy
  has_one :profile, dependent: :destroy
  #has_many :wishlists, dependent: :destroy
  #has_many :emergency, through: :user_emergencies
  has_one :profile_video, dependent: :destroy
  has_one :profile_identity, dependent: :destroy
  has_one :profile_bank, dependent: :destroy
  has_one :profile_keyword, dependent: :destroy
  has_one :pre_mail, dependent: :destroy
  has_many :profile_images, dependent: :destroy
  has_many :listings, dependent: :destroy
  has_many :spots, dependent: :destroy
  has_many :message_thread_users, dependent: :destroy
  has_many :message_threads, through: :message_thread_users, dependent: :destroy
  has_many :ngevents, dependent: :destroy
  has_many :user_campaigns, dependent: :destroy
  has_many :campaigns, :through => :user_campaigns, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :withdrawals, dependent: :destroy
  
  accepts_nested_attributes_for :profile
  #validates :email, presence: true
  #validates :email, uniqueness: true
  #VALID_EMAIL_REGREX = [a-zA-Z0-9_!#$%&*+=?^`{}~|'\-\/\.]+@[a-zA-Z0-9_!#$%&*+=?^`{}~|'\-\/]+(\.[a-zA-Z0-9_!#$%&*+=?^`{}~|'\-\/]+)+
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #validates :email, format: { with: VALID_EMAIL_REGEX }
  #validates :password, presence: true
  #validates :password, length: 6..32
  
  enum user_type: { guest: 0, main_guide: 1, support_guide: 2}

  scope :mine, -> user_id { where(id: user_id) }
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil, create_email=false)
    unless user = User.where(provider: auth.provider, uid: auth.uid).first
      user = User.new(
        provider: auth.provider,
        uid:      auth.uid,
        email:    auth.info.email,
        password: Devise.friendly_token[0,20]
      )
    end
    user.skip_confirmation! if !create_email and !user.unconfirmed?
    user.save

    unless Profile.exists?(user_id: user.id)
      profile = Profile.new(
        user_id: user.id,
        last_name: auth.info.last_name || '',
        first_name: auth.info.first_name || ''
      )
      profile.save

      unless ProfileImage.exists?(user_id: user.id, profile_id: profile.id)
        profile_image = ProfileImage.new(
          user_id: user.id,
          profile_id: profile.id,
          caption: ''
        )
        profile_image.remote_image_url = auth['info']['image'].gsub('http://','https://')
        profile_image.save
      end
    end

    auth_obj = Auth.where(user_id: user.id, provider: auth.provider).first
    if auth_obj.present?
      auth_obj.access_token = auth.credentials.token
    else
      auth_obj = Auth.new(
        user_id: user.id,
        provider: auth.provider,
        uid: auth.uid,
        access_token: auth.credentials.token
      )
    end
    auth_obj.save

    user
  end

  def self.create_unique_string
    SecureRandom.uuid
  end

  def self.user_id_to_profile_id(user_id)
    user = User.find(user_id)
    user.profile.id
  end

  def finish_reservation_count
    Reservation.as_host(self.id).accepts.finished_before_yesterday.count
  end

  def already_authrized
    ProfileIdentity.where(user_id: self.id).first.try('authorized') || false
  end
  
  def favorite_listings
    FavoriteListing.without_soft_destroyed.where(from_user_id: self.id)
  end
  
  def favorite_listings_deleted(listing=nil)
    if listing
      FavoriteListing.only_soft_destroyed.where(from_user_id: self.id, listing_id: listing.id).first
    else
      FavoriteListing.only_soft_destroyed.where(from_user_id: self.id)
    end
  end
  
  def favorite_users_deleted(to_user_id=nil)
    if to_user_id
      FavoriteUser.only_soft_destroyed.where(from_user_id: self.id, to_user_id: to_user_id).first
    else
      FavoriteUser.only_soft_destroyed.where(from_user_id: self.id)
    end
  end
  
  def favorite_users_of_from_user
    FavoriteUser.without_soft_destroyed.where(from_user_id: self.id)
  end
  
  def favorite_users_of_to_user
    FavoriteUser.without_soft_destroyed.where(to_user_id: self.id)
  end

  def favorite_listing?(listing)
    self.favorite_listings.exists?(listing: listing)
  end

  def favorite_user?(to_user)
    self.favorite_users_of_from_user.exists?(to_user_id: to_user)
  end
  
  def get_favorite_of_this_target(target)
    if target.model_name == 'Spot'
      return FavoriteSpot.without_soft_destroyed.where(from_user_id: self.id, spot_id: target.id).first
    elsif target.model_name == 'User'
      return FavoriteUser.without_soft_destroyed.where(from_user_id: self.id, to_user_id: target.id).first
    elsif target.model_name == 'Listing'
      return FavoriteListing.without_soft_destroyed.where(from_user_id: self.id, listing_id: target.id).first
    end
  end
  
  def bookmarked_histories
    mixed_array = FavoriteListing.where(listing_id: self.listings.ids) + FavoriteUser.where(to_user_id: self.id) + FavoriteSpot.where(spot_id: self.spots.ids).includes(:spot)
    mixed_array.sort{|f,s| s.created_at <=> f.created_at}
  end
  
  def unread_bookmark_count
    FavoriteListing.where(listing_id: self.listings.ids, read_at: nil).count + FavoriteUser.where(to_user_id: self.id, read_at: nil).count + FavoriteSpot.where(spot_id: self.spots.ids, read_at: nil).count
  end
  
  def mark_all_bookmarks_as_read
    favorite_listings = FavoriteListing.where(listing_id: self.listings.ids, read_at: nil)
    favorite_listings.update_all(read_at: Time.zone.now)
    favorite_users = FavoriteUser.where(to_user_id: self.id, read_at: nil)
    favorite_users.update_all(read_at: Time.zone.now)
    favorite_spots = FavoriteSpot.where(spot_id: self.spots.ids, read_at: nil)
    favorite_spots.update_all(read_at: Time.zone.now)
  end
  
  def delete_children
    favorite_users = FavoriteUser.where('from_user_id = ? or to_user_id = ?', self.id, self.id)
    favorite_users.destroy_all if favorite_users.present?
    
    favorite_listings = FavoriteListing.where(listing_id: self.id)
    favorite_listings.destroy_all if favorite_listings.present?
    
    profile_categories = ProfileCategory.where(profile_id: self.profile.id)
    profile_categories.destroy_all if profile_categories.present?
    
    profile_languages = ProfileLanguage.where(profile_id: self.profile.id)
    profile_languages.destroy_all if profile_languages.present?
    
    profile_keywords = ProfileKeyword.where(profile_id: self.profile.id)
    profile_keywords.destroy_all if profile_keywords.present?
    
    auth = Auth.where(user_id: self.id)
    auth.destroy_all if auth.present?
    
    self.profile_identity.destroy if self.profile_identity.present?
    self.profile_bank.destroy if self.profile_bank.present?
    self.pre_mail.destroy if self.pre_mail.present?
    self.profile_images.each do |profile_image|
      profile_image.remove_image!
      profile_image.destroy
    end
    
    self.listings.each do |listing|
      listing.delete_children
      listing.soft_destroy
    end
    
    self.profile.soft_destroy
  end
  
  def cancel_reservations
    self.comming_reservations_as_guest.each do |reservation|
      ng_event = Ngevent.find_by(reservation_id: reservation.id)
      ng_event.update_attribute(:active, 0)
      
      reservation.progress = 'canceled_after_accepted'
      reservation.reason = Settings.reservation.reason.withdraw_as_guest
      reservation.refund_rate = Settings.payment.refunds.withdraw_as_guest
      reservation.cancel_by = 'guest_less_than_days'
      reservation.save
    end
    
    self.comming_reservations_as_guide.each do |reservation|
      reservation.progress = 'canceled_after_accepted'
      reservation.reason = Settings.reservation.reason.withdraw_as_guide
      reservation.cancel_by = 'guide'
      payment = reservation.payment
      if payment.present? and payment.completed? and payment.cancel_available_for_withdraw(reservation)
        response = refund_full(payment)
        if response.success?
          payment.transaction_id = response.params['refund_transaction_id']
          payment.refund_date = response.params['timestamp']
          payment.status = 'refunded'
          reservation.refund_rate = Settings.payment.refunds.withdraw_as_guide
          reservation.payment = payment
        else
          payment.refund_disabled!
          reservation.refund_rate = 0
          reservation.payment = payment
        end
      else
        payment.refund_disabled! unless payment.cancel_available_for_withdraw(reservation)
        reservation.payment = payment
      end
      if reservation.campaign.present?
        Campaign.remove_used_code(reservation)
      end
      reservation.save
    end
  end
  
  def update_user_for_close(reason)
    email_before_closed = self.email
    self.reason = reason
    self.email = SecureRandom.urlsafe_base64(8).to_s + email_before_closed
    self.email_before_closed = email_before_closed
    self.uid = User.create_unique_string
    self.skip_reconfirmation!
    self.save
  end
  
  # Deviseの認証に関わる箇所
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    self.without_soft_destroyed.where(conditions.to_h).first
  end
  
  def comming_reservations_as_guest
    Reservation.all.as_guest(self.id).accepts.not_finished
  end
  
  def comming_reservations_as_guide
    Reservation.all.as_host(self.id).accepts.not_finished
  end
  
  def friends_profiles
    users = self.friends
    Profile.where(user_id: users.ids)
  end
  
  def requested_friends_profiles
    users = self.requested_friends
    Profile.where(user_id: users.ids)
  end
  
  def pending_friends_profiles
    users = self.pending_friends
    Profile.where(user_id: users.ids)
  end
  
  def not_friends_profiles
    ids = []
    ids << self.profile.id
    ids << self.friends_profiles.ids if self.friends_profiles.present?
    Profile.main_and_support_guides.where.not(id: ids)
  end
  
  def friend_pending?(user_id)
    self.pending_friends.where(id: user_id).present?
  end
  
  def friend_requested?(user_id)
    self.requested_friends.where(id: user_id).present?
  end
  
  def search_friends(search_params)
    users = self.friends.joins(:profile).merge(Profile.contains?(search_params[:keyword]))
    Profile.where(user_id: users.ids).order_by_created_at_asc
  end
  
  def search_not_friends(search_params)
    self.not_friends_profiles.contains?(search_params[:keyword]).order_by_created_at_asc
  end
  
  def unconfirmed?
    self.confirmation_sent_at.present? and self.confirmed_at.blank?
  end
  
  def active_listings
    self.listings.without_soft_destroyed.order_by_updated_at_desc
  end
  
  def message_return_rate
    guest_threads = GuestThread.where(host_id: self.id, reply_from_host: true, first_message: false)
    array = guest_threads
    array.each do |guest_thread|
      guest_threads = guest_threads.where.not(id: guest_thread.id) if guest_thread.origin_message.created_at < Settings.response_rate.begining_date or guest_thread.message_from_guide?(self.id)
    end
    total_count = guest_threads.count
    return_in_1day_count = 0
    
    return '-' if total_count < 3
    
    guest_threads.each do |guest_thread|
      guest_id = guest_thread.counterpart_user(self.id)
      guest_first_message = guest_thread.messages.where(from_user_id: guest_id).order_by_created_at_asc.first
      
      guide_returned_message = guest_thread.messages.where('from_user_id = ? and created_at > ?', self.id, guest_first_message.created_at.in_time_zone('UTC')).order_by_created_at_asc.first
      next if guide_returned_message.created_at - guest_first_message.created_at > 24.hour
      return_in_1day_count += 1
    end
    (return_in_1day_count / total_count.to_f * 100).round.to_s + '%'
  end
  
  def active?
    current_user.last_access_date.present? and current_user.last_access_date > Time.zone.today - Settings.user.active_period.days
  end
end
