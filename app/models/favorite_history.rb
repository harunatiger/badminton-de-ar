# == Schema Information
#
# Table name: favorite_histories
#
#  id           :integer          not null, primary key
#  from_user_id :integer          not null
#  to_user_id   :integer
#  listing_id   :integer
#  read_at      :datetime
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_favorite_histories_on_from_user_id  (from_user_id)
#  index_favorite_histories_on_listing_id    (listing_id)
#  index_favorite_histories_on_to_user_id    (to_user_id)
#  index_favorite_histories_on_type          (type)
#

class FavoriteHistory < ActiveRecord::Base
  
  def listing_history?
    self.model_name == 'FavoriteListingHistory'
  end
  
  def user_history?
    self.model_name == 'FavoriteUserHistory'
  end
end
