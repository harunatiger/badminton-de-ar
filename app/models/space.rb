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

class Space < Option
end
