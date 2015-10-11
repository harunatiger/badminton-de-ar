# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Language < ActiveRecord::Base
  has_many :listing_languages, dependent: :destroy
  has_many :listings, :through => :listing_languages, dependent: :destroy
  has_many :profile_languages, dependent: :destroy
  has_many :profiles, :through => :profile_languages, dependent: :destroy
end
