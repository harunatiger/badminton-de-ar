# == Schema Information
#
# Table name: options
#
#  id         :integer          not null, primary key
#  name       :string           default("")
#  type       :string           default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_options_on_name  (name)
#  index_options_on_type  (type)
#

class Option < ActiveRecord::Base
  has_many :listing_detail_options, dependent: :destroy
  has_many :listing_details, :through => :listing_detail_options, dependent: :destroy
  has_many :reservation_options, dependent: :destroy
  has_many :reservations, :through => :reservation_options, dependent: :destroy
end
