namespace :review_open do
 desc 'open reviews'
  task do: :environment do
    p reservations = Reservation.accepts.review_expiration_date_is_before_yesterday.review_not_opened_yet
    reservations.update_all(review_opened_at: Time.zone.now)
  end
end
