# == Schema Information
#
# Table name: help_topics
#
#  id               :integer          not null, primary key
#  help_category_id :integer
#  title_ja         :string
#  title_en         :string
#  body_ja          :text
#  body_en          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_help_topics_on_help_category_id  (help_category_id)
#

class HelpTopic < ActiveRecord::Base
  belongs_to :help_category

  scope :select_topics, -> help_category_id { where(help_category_id: help_category_id) }

  def body
    send "body_#{I18n.locale}"
  end

  def title
    send "title_#{I18n.locale}"
  end
end
