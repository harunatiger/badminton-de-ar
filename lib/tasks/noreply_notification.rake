namespace :noreply_notification do
  desc 'send mail for noreply notification'
  task send: :environment do
    MessageThread.noreply_push_mail.each do |mt|
      m = mt.messages.last
      if m.present?
        if mt.host_id.to_i == m.to_user_id.to_i
          second = Message.time_ago(m)
          if second >= 86400
            ReplyMailer.send_reply_mail_to_host(m).deliver_now!
            ReplyMailer.send_reply_mail_to_admin(m).deliver_now!
            mt.update_attribute(:noticemail_sended, 1)
          end
        end
      end
    end
  end
end
