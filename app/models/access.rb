# == Schema Information
#
# Table name: accesses
#
#  id          :integer          not null, primary key
#  session_id  :string
#  user_id     :integer
#  page        :string
#  referer     :string
#  country     :string
#  devise      :string
#  accessed_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_accesses_on_session_id  (session_id)
#  index_accesses_on_user_id     (user_id)
#

class Access < ActiveRecord::Base
  def self.insert_record(access_params)
    Access.create(
      session_id: access_params[:session_id].presence || '',
      user_id: access_params[:user_id].presence || nil,
      method: access_params[:method].presence || '',
      page: access_params[:page].presence || '',
      referer: access_params[:referer].presence || '',
      country: access_params[:country].presence || '',
      devise: access_params[:devise].presence || '',
      accessed_at: access_params[:accessed_at].presence || '')
  end
end
