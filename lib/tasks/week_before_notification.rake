namespace :week_before_notification do
  desc 'send a week before notification mails'
  task send: :environment do
    reservations = Reservation.accepts.week_before
    reservations.each do |r|
      ReservationMailer.send_week_before_notification(r,r.host_id).deliver_now!
      ReservationMailer.send_week_before_notification(r,r.guest_id).deliver_now!
    end
  end
end
