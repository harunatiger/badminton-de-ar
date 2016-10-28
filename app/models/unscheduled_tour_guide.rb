# == Schema Information
#
# Table name: unscheduled_tour_guides
#
#  id                  :integer          not null, primary key
#  unscheduled_tour_id :integer
#  pair_guide_id       :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_unscheduled_tour_guides_on_pair_guide_id        (pair_guide_id)
#  index_unscheduled_tour_guides_on_unscheduled_tour_id  (unscheduled_tour_id)
#

class UnscheduledTourGuide < ActiveRecord::Base
  belongs_to :unscheduled_tour
  belongs_to :user, foreign_key: 'pair_guide_id'
  
  validates :unscheduled_tour_id, :pair_guide_id, presence: true
end
