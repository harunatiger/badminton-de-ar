namespace :day_before_notification do
  desc 'send a day before notification mails'
  task send: :environment do
    reservations = Reservation.accepts.day_before
    reservations.each do |r|
      ReservationMailer.send_day_before_notification(r,r.host_id).deliver_now!
      ReservationMailer.send_day_before_notification(r,r.guest_id).deliver_now!
    end
  end
end
