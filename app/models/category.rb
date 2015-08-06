# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
  has_many :listing_categories, dependent: :destroy
  has_many :listings, :through => :listing_categories, dependent: :destroy
end
