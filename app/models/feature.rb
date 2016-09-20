# == Schema Information
#
# Table name: features
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  url          :string           not null
#  order_number :integer          not null
#  image        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Feature < ActiveRecord::Base
  validates :title, presence: true
  validates :url, presence: true
  validates :order_number, presence: true
  validates :image, presence: true
  validates :image_sp, presence: true
  validates :order_number, uniqueness: true
  validates :url, uniqueness: true
  
  mount_uploader :image, FeatureUploader
  mount_uploader :image_sp, FeatureUploader
end
