namespace :review_open do
 desc 'open reviews'
  task do: :environment do
    p reservations = Reservation.accepts.review_expiration_date_is_before_yesterday.review_not_opened_yet
    reservations.each do |reservation|
      reservation.update(review_opened_at: Time.zone.now)
      for_guide = false
      reservation.reviews.each do |review|
        if review.for_guide?
          for_guide = true
        end
        review.re_calc_average
      end
      reservation.create_pair_guide_review if for_guide
    end
  end
end
