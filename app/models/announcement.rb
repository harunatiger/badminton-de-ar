# == Schema Information
#
# Table name: announcements
#
#  id               :integer          not null, primary key
#  title            :string           default("")
#  page_url         :string           default(""), not null
#  posting_start_at :date             not null
#  posting_end_at   :date             not null
#  banner_image_pc  :string           default("")
#  banner_image_sp  :string           default("")
#  banner_space     :string           default("")
#  publish_date     :date
#  overview         :text             default("")
#  external_url     :string           default("")
#  detail_html      :text             default("")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_announcements_on_posting_end_at    (posting_end_at)
#  index_announcements_on_posting_start_at  (posting_start_at)
#  index_announcements_on_title             (title)
#

class Announcement < ActiveRecord::Base
  mount_uploader :banner_image_pc, AnnouncementImageUploader
  mount_uploader :banner_image_sp, AnnouncementImageUploader
  attr_accessor :image_blank_ok
  
  validates :title, :page_url, :posting_start_at, :posting_end_at, :banner_image_pc, :banner_image_sp, :banner_space, :publish_date, :overview, :detail_html, presence: true
  validates :external_url, format: /\A#{URI::regexp(%w(http https))}\z/, allow_blank: true
  validates :page_url, uniqueness: true
end
