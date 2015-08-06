# == Schema Information
#
# Table name: listing_languages
#
#  id          :integer          not null, primary key
#  listing_id  :integer
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_listing_languages_on_language_id  (language_id)
#  index_listing_languages_on_listing_id   (listing_id)
#

class ListingLanguage < ActiveRecord::Base
  belongs_to :listing
  belongs_to :language
end
