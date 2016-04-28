# == Schema Information
#
# Table name: profiles
#
#  id                   :integer          not null, primary key
#  user_id              :integer          not null
#  first_name           :string           default("")
#  last_name            :string           default("")
#  birthday             :date
#  gender               :integer
#  phone                :string           default("")
#  phone_verification   :boolean          default(FALSE)
#  zipcode              :string           default("")
#  location             :string           default("")
#  self_introduction    :text             default("")
#  school               :string           default("")
#  work                 :string           default("")
#  timezone             :string           default("")
#  listing_count        :integer          default(0)
#  wishlist_count       :integer          default(0)
#  bookmark_count       :integer          default(0)
#  reviewed_count       :integer          default(0)
#  reservation_count    :integer          default(0)
#  ave_total            :float            default(0.0)
#  ave_accuracy         :float            default(0.0)
#  ave_communication    :float            default(0.0)
#  ave_cleanliness      :float            default(0.0)
#  ave_location         :float            default(0.0)
#  ave_check_in         :float            default(0.0)
#  ave_cost_performance :float            default(0.0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  country              :string           default("")
#  progress             :integer          default(0), not null
#  prefecture           :string           default("")
#  municipality         :string           default("")
#  other_address        :string           default("")
#  soft_destroyed_at    :datetime
#  free_field           :text             default("")
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#

class Profile < ActiveRecord::Base
  acts_as_taggable
  soft_deletable
  soft_deletable dependent_associations: [:user]
  
  belongs_to :user
  has_one :profile_video, dependent: :destroy
  has_one :profile_identity, dependent: :destroy
  has_one :profile_bank, dependent: :destroy
  has_one :profile_keyword, dependent: :destroy
  has_many :profile_images, dependent: :destroy
  has_many :profile_categories, dependent: :destroy
  has_many :categories, :through => :profile_categories, dependent: :destroy
  has_many :profile_languages, dependent: :destroy
  has_many :languages, :through => :profile_languages, dependent: :destroy

  enum gender: { female: 0, male: 1, others: 2, not_specified: 3 }

  attr_accessor :enable_strict_validation
  accepts_nested_attributes_for :profile_categories, allow_destroy: true

  validates :user_id, presence: true
  validates :user_id, uniqueness: true
  validate :last_name_presence, if: :enable_strict_validation, on: :update
  validates :first_name, :country, :phone, presence: true, if: :enable_strict_validation, on: :update
  VALID_PHONE_REGEX = /\A[-+0-9]+\z/
  validates :phone, format: { with: VALID_PHONE_REGEX, if: :enable_strict_validation, on: :update }
  
  scope :contains?, -> name { where('last_name like ? or first_name like ?', '%' + name + '%', '%' + name + '%') }

  def last_name_presence
    if self.last_name.empty?
      errors[:base] << "Family Name can't be blank"
    end
  end

  def self.minimun_requirement?(user_id)
    profile = Profile.where(user_id: user_id).first
    if profile.first_name.present? &&
      profile.last_name.present? &&
      profile.birthday.present? &&
      profile.phone.present? &&
      profile.location.present? &&
      profile.self_introduction.present?
      return true
    else
      return false
    end
  end

  def self.mine(user_id)
    Profile.where(user_id: user_id).first
  end

  def self.guides
    user_ids = Listing.where(open: true).pluck(:user_id).uniq
    users = User.where(id: user_ids).without_soft_destroyed
    Profile.where(user_id: users.ids)
  end
  
  def self.main_and_support_guides
    user_ids = User.main_guide.without_soft_destroyed + User.support_guide.without_soft_destroyed
    users = User.where(id: user_ids)
    Profile.where(user_id: users.ids)
  end

  def self.get_percentage(id)
    user = User.find(id)
    hash_result = {}
    if user
      profile = user.profile
      if profile
        #birthday
        hash_result.store('birthday', 'true') if profile.birthday.blank?
        #country
        hash_result.store('country', 'true') if profile.country.blank?
        #location
        hash_result.store('location', 'true') if profile.location.blank?
        #email
        hash_result.store('email', 'true') if user.email.blank?
        #phone
        hash_result.store('phone', 'true') if profile.phone.blank?
        #self_introduction
        hash_result.store('self_introduction', 'true') if profile.self_introduction.blank?

        # Caliculate Remain Percentage
        if hash_result.present?
          ret = (((100 * hash_result.length).to_f / 6).round) / hash_result.length
          hash_result.store('rate', ret) if ret
        end

      end
    end
    hash_result
  end

  def self.set_percentage(id)
    user = User.find(id)
    if user
      profile = user.profile
      if profile
        array_result = []
        #birthday
        array_result << 'birthday' if profile.birthday.present?
        #country
        array_result << 'country' if profile.country.present?
        #location
        array_result << 'location' if profile.location.present?
        #email
        array_result << 'email' if user.email.present?
        #phone
        array_result << 'phone' if profile.phone.present?
        #self_introduction
        array_result << 'self_introduction' if profile.self_introduction.present?

        # Caliculate Percentage
        ret = ((100 / 6.to_f) * array_result.length).round
        profile.progress = ret.to_i
        profile.update({:listing_count => ret})
      end
    end
  end
  
  def cover
    self.profile_images.where(cover_flg: true).first
  end
  
  def thumb_images
    self.profile_images.where.not(cover_flg: true).where.not(image: '').order('order_num')
  end
  
  def thumb_image
    self.thumb_images.first
  end
  
  def category_selected?(category_name)
    result = false
    self.profile_categories.each do |profile_category|
      if Category.find(profile_category.category_id).name == category_name
        result = true
        break
      end
    end
    result
  end
end
