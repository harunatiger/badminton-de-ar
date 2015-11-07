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
#  progress             :integer
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#

class Profile < ActiveRecord::Base
  belongs_to :user
  has_one :profile_image, dependent: :destroy
  has_one :profile_video, dependent: :destroy
  has_one :profile_identity, dependent: :destroy
  has_one :profile_bank, dependent: :destroy
  has_many :profile_categories, dependent: :destroy
  has_many :categories, :through => :profile_categories, dependent: :destroy
  has_many :profile_languages, dependent: :destroy
  has_many :languages, :through => :profile_languages, dependent: :destroy

  enum gender: { female: 0, male: 1, others: 2, not_specified: 3 }

  validates :user_id, presence: true

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
    users = User.where(id: user_ids)
    Profile.where(user_id: users.ids)
  end

  def self.set_percentage(id)
    has_allotate = {
      :first_name => 5,
      :last_name  => 5,
      :birthday   => 10,
      :phone      => 10,
      :location   => 10,
      :self_introduction  => 10,
      :school     => 10,
      :work       => 10,
      :bank       => 10,
      :authorized => 10,
      :category   => 10,
      :image      => 10,
      :coverimage => 10
    }
      
    array_result = []
    profile=Profile.find(id)
    array_result << has_allotate[:first_name] if profile.first_name.present?
    array_result << has_allotate[:last_name] if profile.last_name.present?
    array_result << has_allotate[:birthday] if profile.birthday.present?
    array_result << has_allotate[:phone] if profile.phone.present?
    array_result << has_allotate[:location] if profile.location.present?
    array_result << has_allotate[:self_introduction] if profile.self_introduction.present?
    array_result << has_allotate[:school] if profile.school.present?
    array_result << has_allotate[:work] if profile.work.present?
    array_result << has_allotate[:bank] if ProfileBank.where(profile_id: profile.id).where.not(number: '').present?
    if profile_identity = ProfileIdentity.find_by(profile_id: profile.id)
      array_result << has_allotate[:authorized] if profile_identity.authorized? 
    end
    array_result << has_allotate[:category] if ProfileCategory.where(profile_id: profile.id).present?
    array_result << has_allotate[:image] if ProfileImage.where(profile_id: profile.id).where.not(image: '').present?
    array_result << has_allotate[:coverimage] if ProfileImage.where(profile_id: profile.id).where.not(cover_image: '').present? 

    # Calicurate Percentage
    ret = array_result.inject(0) { |sum, i| sum + i }

    profile.progress = ret
    profile.update({:listing_count => ret})

  end

end
