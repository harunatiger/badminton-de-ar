# == Schema Information
#
# Table name: spot_images
#
#  id         :integer          not null, primary key
#  spot_id    :integer          not null
#  image      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_spot_images_on_spot_id  (spot_id)
#

class SpotImage < ActiveRecord::Base
  belongs_to :spot
  
  validates :image, presence: true
  validates :spot_id, uniqueness: true
  
  mount_uploader :image, SpotUploader
  
end
