# == Schema Information
#
# Table name: unscheduled_tours
#
#  id         :integer          not null, primary key
#  listing_id :integer
#  guide_id   :integer
#  uuid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_unscheduled_tours_on_guide_id    (guide_id)
#  index_unscheduled_tours_on_listing_id  (listing_id)
#

class UnscheduledTour < ActiveRecord::Base
  belongs_to :listing
  belongs_to :user, foreign_key: 'guide_id'
  has_many :unscheduled_tour_guides, dependent: :destroy
  has_many :users, :through => :unscheduled_tour_guides, dependent: :destroy
  
  validates :listing_id, :guide_id, :uuid, presence: true
  validates :uuid, uniqueness: true
  after_initialize :set_uuid
  
  def to_param
    uuid
  end
  
  private
  def set_uuid
    self.uuid = self.uuid.blank? ? generate_uuid : self.uuid
  end                                                                                                                                                                                          
  def generate_uuid
    SecureRandom.uuid
  end
end
