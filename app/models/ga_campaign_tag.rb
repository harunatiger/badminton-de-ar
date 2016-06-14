# == Schema Information
#
# Table name: ga_campaign_tags
#
#  id          :integer          not null, primary key
#  default_url :string           default("")
#  long_url    :string           default("")
#  short_url   :string           default("")
#  source      :string           default("")
#  medium      :string           default("")
#  term        :string           default("")
#  content     :string           default("")
#  name        :string           default("")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_ga_campaign_tags_on_long_url   (long_url)
#  index_ga_campaign_tags_on_short_url  (short_url)
#

class GaCampaignTag < ActiveRecord::Base
  after_initialize :set_short_url, if: :new_record?
  after_initialize :set_long_url
  validates :default_url, :short_url, :long_url, :source, :medium, :name, :presence => true
  
  private
  def set_short_url
    self.short_url = SecureRandom.urlsafe_base64(6)
  end
  
  def set_long_url
    long_url = self.default_url + '?utm_source=' + self.source + '&utm_medium=' + self.medium
    long_url = long_url + '&utm_term=' + self.term if self.term.present?
    long_url = long_url + '&utm_content=' + self.content if self.content.present?
    long_url = long_url + '&utm_campaign=' + self.name
    self.long_url = URI.escape(long_url)
  end
end
