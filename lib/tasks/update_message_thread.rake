namespace :update_message_thread do
  desc 'do updating message thread'
  task do: :environment do
    begin
      ActiveRecord::Base.transaction do
        DefaultThread.all.each do |default_thread|
          if default_thread.messages.present?
            from_user = User.find_by_id(default_thread.origin_from_user_id)
            to_user = User.find_by_id(default_thread.origin_to_user_id)
            first_message = default_thread.origin_message
            reply_from_host = false
            if from_user.present? and to_user.present?
              if from_user.guest? and to_user.main_guide?
                guide_id = to_user.id
                reply_from_host = true if default_thread.messages.where(from_user_id: guide_id).present?
              elsif from_user.main_guide? and to_user.guest? and first_message.content == Settings.message.what_talk_about.to_guest
                guide_id = from_user.id
                reply_from_host = true if default_thread.messages.where.not(id: first_message.id).where(from_user_id: guide_id).present?
              else
                guide_id = ''
              end
              
              if guide_id.present?
                guest = default_thread.counterpart_user(guide_id)
                if message_thread_id = GuestThread.exists_thread?(guide_id, guest.id)
                  message_thread = GuestThread.find(message_thread_id)
                  if message_thread.messages.blank?
                    message_thread.destroy!
                    p default_thread.update!(type: 'GuestThread', host_id: host_id, reply_from_host: reply_from_host, first_message: !reply_from_host)
                  end
                else
                  p default_thread.update!(type: 'GuestThread', host_id: host_id, reply_from_host: reply_from_host, first_message: !reply_from_host)
                end
              end
            end
          else
            p users = default_thread.users
            user_1 = users[0]
            user_2 = users[1]
            
            if user_1.present? and user_2.present?
              if user_1.main_guide? and user_2.guest?
                p default_thread.update!(type: 'GuestThread', host_id: user_1.id, reply_from_host: false, first_message: true)
              elsif user_1.guest? and user_2.main_guide?
                p default_thread.update!(type: 'GuestThread', host_id: user_2.id, reply_from_host: false, first_message: true)
              end
            end
          end
        end
      end
    rescue ActiveRecord::Rollback
    end
  end
end
