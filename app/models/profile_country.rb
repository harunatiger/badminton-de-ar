# == Schema Information
#
# Table name: profile_countries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  profile_id :integer
#  country    :string           default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_profile_countries_on_country     (country)
#  index_profile_countries_on_profile_id  (profile_id)
#  index_profile_countries_on_user_id     (user_id)
#

class ProfileCountry < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile
  
  def country_name
    c = ISO3166::Country[country]
    c.translations[I18n.locale.to_s] || c.name
  end
end
