# == Schema Information
#
# Table name: reviews
#
#  id                  :integer          not null, primary key
#  guest_id            :integer
#  host_id             :integer
#  reservation_id      :integer
#  listing_id          :integer
#  accuracy            :integer          default(0)
#  communication       :integer          default(0)
#  clearliness         :integer          default(0)
#  location            :integer          default(0)
#  check_in            :integer          default(0)
#  cost_performance    :integer          default(0)
#  total               :integer          default(0)
#  msg                 :text             default("")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  type                :string           not null
#  tour_image          :string           default("")
#  unscheduled_tour_id :integer
#
# Indexes
#
#  index_reviews_on_guest_id             (guest_id)
#  index_reviews_on_host_id              (host_id)
#  index_reviews_on_listing_id           (listing_id)
#  index_reviews_on_reservation_id       (reservation_id)
#  index_reviews_on_unscheduled_tour_id  (unscheduled_tour_id)
#

class Review < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: 'host_id'
  belongs_to :user, class_name: 'User', foreign_key: 'guest_id'
  belongs_to :listing
  belongs_to :reservation
  belongs_to :unscheduled_tour

  validates :guest_id, presence: true
  validates :host_id, presence: true
  #validates :reservation_id, presence: true
  validates :listing_id, presence: true
  validates :msg, presence: true
  validates :accuracy, presence: true
  validates :communication, presence: true
  validates :clearliness, presence: true
  validates :location, presence: true
  validates :check_in, presence: true
  validates :cost_performance, presence: true
  validates :total, presence: true
  validates :type, presence: true

  mount_uploader :tour_image, DefaultImageUploader
  attr_accessor :image_blank_ok

  scope :order_by_created_at_desc, -> { order('created_at desc') }
  scope :order_by_updated_at_desc, -> { order('updated_at desc') }
  
  before_validation :set_total

  def calc_average
    self.calc_ave_of_listing
    self.calc_ave_of_profile
  end

  def calc_ave_of_listing
    review = ReviewForGuide.where(reservation_id: self.reservation_id, host_id: self.host_id).first
    if review.present?
      l = Listing.find(self.listing_id)
      r_count = ReviewForGuide.where(listing_id: self.listing_id, host_id: self.host_id).joins(:reservation).merge(Reservation.review_open?).count
    
      if r_count == 1
        ave_total = review.total
      else
        ave_total = (l.ave_total * (r_count - 1) + review.total) / r_count
      end
      l.ave_total = ave_total
      l.save
    end
  end

  def calc_ave_of_profile
    review_for_guide = ReviewForGuide.where(reservation_id: self.reservation_id, host_id: self.host_id).first
    review_for_guest = ReviewForGuest.where(reservation_id: self.reservation_id)
    host = User.find(self.host_id)
    guest = User.find(self.guest_id)

    if review_for_guide.present?
      prof = Profile.find(host.profile.id)
      r_count = Review.my_reviewed_count(host.id)
      if r_count == 1
        ave_total = review_for_guide.total
      else
        ave_total = (prof.ave_total * (r_count - 1) + review_for_guide.total) / r_count
      end
      prof.ave_total = ave_total
      prof.enable_strict_validation = false
      prof.save
    end

    if review_for_guest.present?
      prof = Profile.find(guest.profile.id)
      r_count = Review.my_reviewed_count(guest.id)
      if r_count == 1
        ave_total = review_for_guest.total
      else
        ave_total = (prof.ave_total * (r_count - 1) + review_for_guest.total) / r_count
      end
      prof.ave_total = ave_total
      prof.enable_strict_validation = false
      prof.save
    end
  end
  
  def re_calc_average
    self.re_calc_ave_of_listing
    self.re_calc_ave_of_profile
  end
  
  def re_calc_ave_of_listing
    l = Listing.find(self.listing_id)
    if self.host_id == l.user_id
      listing_reviews = ReviewForGuide.where(listing_id: l.id, host_id: l.user_id).joins(:reservation).merge(Reservation.review_open?)
      listing_reviews += ReviewOfUnscheduledTour.where(listing_id: l.id, host_id: l.user_id)
      r_count = listing_reviews.count
    
      if r_count == 1
        ave_total = self.total
      else
        ave_total = 0
        listing_reviews.each do |review|
          ave_total += self.total
        end
        ave_total = ave_total.quo(r_count)
      end
      l.ave_total = ave_total
      l.save
    end
  end

  def re_calc_ave_of_profile
    if self.for_guide?
      prof = Profile.find_by_user_id(self.host_id)
    elsif self.for_guest?
      prof = Profile.find_by_user_id(self.guest_id)
    elsif self.for_unscheduled_tour?
      prof = Profile.find_by_user_id(self.host_id)
    end
    
    reviews = Review.mine(prof.user_id)
    r_count = reviews.count
    if r_count == 1
      ave_total = self.total
    else
      ave_total = 0
      reviews.each do |review|
        ave_total += review.total
      end
      ave_total = ave_total.quo(r_count)
    end
    prof.ave_total = ave_total
    prof.enable_strict_validation = false
    prof.save
  end

  def for_guide?
    self.type == 'ReviewForGuide'
  end

  def for_guest?
    self.type == 'ReviewForGuest'
  end
  
  def for_unscheduled_tour?
    self.type == 'ReviewOfUnscheduledTour'
  end
  
  def self.mine(user_id)
    self.reviewed_as_guest(user_id) + self.reviewed_as_guide(user_id)
  end

  def self.my_reviewed_count(user_id)
    reviewed_as_guide_count = ReviewForGuide.reviewed_as_guide(user_id).count
    review_for_guest_count = ReviewForGuest.reviewed_as_guest(user_id).count
    reviewed_as_guide_count + review_for_guest_count
  end

  def self.reviewed_as_guest(user_id)
    ReviewForGuest.where(guest_id: user_id).joins(:reservation).merge(Reservation.review_open?).order_by_updated_at_desc
  end

  def self.reviewed_as_guide(user_id)
    review_for_guide_ids = ReviewForGuide.where(host_id: user_id).joins(:reservation).merge(Reservation.review_open?).pluck(:id)
    review_for_unscheduled_tour_ids = ReviewOfUnscheduledTour.where(host_id: user_id).pluck(:id)
    Review.where(id: review_for_guide_ids.concat(review_for_unscheduled_tour_ids)).order_by_updated_at_desc
  end

  def self.this_listing(listing)
    review_for_guide_ids = ReviewForGuide.where(listing_id: listing.id, host_id: listing.user_id).joins(:reservation).merge(Reservation.review_open?).pluck(:id)
    review_for_unscheduled_tour_ids = ReviewOfUnscheduledTour.where(listing_id: listing.id, host_id: listing.user_id).pluck(:id)
    Review.where(id: review_for_guide_ids.concat(review_for_unscheduled_tour_ids)).order_by_updated_at_desc
  end
  
  def set_total
    self.total = nil if self.total == 0
  end
  
  def anothre_review_exist?
    ReviewForGuest.all.where.not(id: self.id).where(guest_id: self.guest_id, reservation_id: self.reservation_id).present?
  end
  
  def host_review
    listing = Listing.find(self.listing_id)
    ReviewForGuide.where(reservation_id: self.reservation_id, host_id: listing.user_id).first
  end
end
