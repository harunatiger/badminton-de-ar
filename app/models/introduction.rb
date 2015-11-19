# == Schema Information
#
# Table name: campaigns
#
#  id         :integer          not null, primary key
#  code       :string           not null
#  discount   :integer
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_campaigns_on_code      (code)
#  index_campaigns_on_discount  (discount)
#  index_campaigns_on_type      (type)
#

class Introduction < Campaign
  validates :discount, presence: true
  after_initialize :set_default, if: :new_record?

  attr_accessor :used_total_price
  
  private
  def set_default
    self.code = SecureRandom.urlsafe_base64(6)
  end
end
