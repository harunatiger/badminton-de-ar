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
  has_many :message_thread_users, dependent: :destroy
  has_many :message_threads, through: :message_thread_users, dependent: :destroy
  has_many :ngevents, dependent: :destroy
  has_many :user_campaigns, dependent: :destroy
  has_many :campaigns, :through => :user_campaigns, dependent: :destroy
  has_many :favorite_listing, dependent: :destroy
  has_many :favorite_users_of_from_user, class_name: 'FavoriteUser', foreign_key: 'from_user_id', dependent: :destroy
  has_many :favorite_users_of_to_user, class_name: 'FavoriteUser', foreign_key: 'to_user_id', dependent: :destroy

  #validates :email, presence: true
  #validates :email, uniqueness: true
  #VALID_EMAIL_REGREX = [a-zA-Z0-9_!#$%&*+=?^`{}~|'\-\/\.]+@[a-zA-Z0-9_!#$%&*+=?^`{}~|'\-\/]+(\.[a-zA-Z0-9_!#$%&*+=?^`{}~|'\-\/]+)+
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #validates :email, format: { with: VALID_EMAIL_REGEX }
  #validates :password, presence: true
  #validates :password, length: 6..32

  scope :mine, -> user_id { where(id: user_id) }
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    unless user = User.where(provider: auth.provider, uid: auth.uid).first
      user = User.new(
        provider: auth.provider,
        uid:      auth.uid,
        email:    auth.info.email,
        password: Devise.friendly_token[0,20]
      )
    end
    user.skip_confirmation!
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

  def favorite_listing?(listing)
    self.favorite_listing.exists?(listing: listing)
  end

  def favorite_user?(to_user)
    self.favorite_users_of_from_user.exists?(to_user_id: to_user)
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
  
  def not_friends_profiles
    return Profile.guides.where.not(id: self.profile.id) if self.friends_profiles.blank?
    return Profile.guides.where.not(id: self.friends_profiles.ids).where.not(id: self.profile.id)
  end
  
  def search_friends(search_params)
    users = self.friends.joins(:profile).merge(Profile.contains?(search_params[:keyword]))
    Profile.where(user_id: users.ids)
  end
  
  def search_not_friends(search_params)
    self.not_friends_profiles.contains?(search_params[:keyword])
  end
end
