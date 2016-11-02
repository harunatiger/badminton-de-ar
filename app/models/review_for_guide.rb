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

class ReviewForGuide < Review
  validates :reservation_id, presence: true

  mount_uploader :tour_image, DefaultImageUploader
  attr_accessor :image_blank_ok
end
