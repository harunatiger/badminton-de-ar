# == Schema Information
#
# Table name: listing_detail_options
#
#  id                :integer          not null, primary key
#  listing_detail_id :integer
#  option_id         :integer
#  price             :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_listing_detail_options_on_listing_detail_id  (listing_detail_id)
#  index_listing_detail_options_on_option_id          (option_id)
#  index_listing_detail_options_on_price              (price)
#

class ListingDetailOption < ActiveRecord::Base
  belongs_to :listing_detail
  belongs_to :option
end
