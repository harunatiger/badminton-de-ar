# == Schema Information
#
# Table name: help_categories
#
#  id         :integer          not null, primary key
#  name_ja    :string
#  name_en    :string
#  parent_id  :integer
#  lft        :integer
#  rgt        :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_help_categories_on_lft        (lft)
#  index_help_categories_on_parent_id  (parent_id)
#  index_help_categories_on_rgt        (rgt)
#

class HelpCategory < ActiveRecord::Base
  acts_as_nested_set

  has_many :help_topics
  
  before_save :set_id

  default_scope -> { order(lft: :asc) }

  def name
    send "name_#{I18n.locale}"
  end
  
  def set_id
    self.id = HelpCategory.last.id + 1 if self.id.blank?
  end
end
