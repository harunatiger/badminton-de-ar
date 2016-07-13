# == Schema Information
#
# Table name: profile_images
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  profile_id  :integer
#  image       :string           default(""), not null
#  caption     :string           default("")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cover_image :string           default("")
#  order_num   :integer
#  cover_flg   :boolean          default(FALSE)
#
# Indexes
#
#  index_profile_images_on_profile_id  (profile_id)
#  index_profile_images_on_user_id     (user_id)
#

class ProfileImage < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile

  mount_uploader :image, DefaultImageUploader
  mount_uploader :cover_image, DefaultImageUploader
  attr_accessor :image_blank_ok
  attr_accessor :image_crop_x
  attr_accessor :image_crop_y
  attr_accessor :image_crop_w
  attr_accessor :image_crop_h
  attr_accessor :image_resize_w
  attr_accessor :image_resize_h

  validates :user_id, presence: true
  validates :profile_id, presence: true
  #validates :profile_id, uniqueness: true
  validates :image, presence: true
  #validates :order_num, numericality: {
  #  only_integer: true,
  #  equal_to: 0 # set has_one association
  #}

  scope :mine, -> user_id { where( user_id: user_id ) }

  def self.minimun_requirement?(user_id, profile_id)
    profile_image = ProfileImage.where(user_id: user_id, profile_id: profile_id).first
    if profile_image.present?
      if profile_image.image.present?
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
  def set_crop_size(imgW, imgH, imgX1, imgY1, cropW, cropH)
    self.image_crop_x = imgX1.to_i
    self.image_crop_y = imgY1.to_i
    self.image_crop_w = cropW.to_i
    self.image_crop_h = cropH.to_i
    self.image_resize_w = imgW.to_i
    self.image_resize_h = imgH.to_i
  end
end
