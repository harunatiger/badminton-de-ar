# == Schema Information
#
# Table name: listing_categories
#
#  id          :integer          not null, primary key
#  listing_id  :integer
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_listing_categories_on_category_id  (category_id)
#  index_listing_categories_on_listing_id   (listing_id)
#

class ListingCategory < ActiveRecord::Base
  belongs_to :listing
  belongs_to :category
end
