class AddColumnsToMessageThreads < ActiveRecord::Migration
  def change
    add_column :message_threads, :reply_from_host, :boolean, default: false
    add_column :message_threads, :first_message, :boolean, default: true
    MessageThread.all.each do |mt|
      m = mt.messages
      if m.present?
        if m.count == 1
          first_message = true
        else
          first_message = false
        end

        m_l = mt.messages.last
        if m_l.present?
          if mt.host_id.to_i == m_l.to_user_id.to_i
            reply_from_host = false
          else
            reply_from_host = true
          end
        end
        mt.record_timestamps = false
        mt.update!(first_message: first_message, reply_from_host: reply_from_host)
        mt.record_timestamps = true
      end
    end
  end
end
