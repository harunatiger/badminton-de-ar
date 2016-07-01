namespace :review_mail do
  desc 'send review mails'
  task send: :environment do
    Settings.review.timing_of_sending_notification.each do |days|
      p reservations = Reservation.accepts.review_not_opened_yet.finished_days_ago(days)
      reservations.each do |r|
        ReviewMailer.send_review_notification(r, days).deliver_now! unless r.guest_review_writed?
        ReviewMailer.send_review_reply_notification(r, days).deliver_now! unless r.review_writed?(r.host_id)
        ReviewMailer.send_review_reply_notification_pair_guide(r, days).deliver_now! if r.pg_completion? and !r.review_writed?(r.pair_guide_id)
      end
      reservations.update_all(review_mail_sent_at: Time.zone.now)
    end
  end
end
