ActiveAdmin.register Reservation do
  permit_params :guest_id, :listing_id, :campaign_id, :schedule, :num_of_people, :progress, :review_mail_sent_at, :review_expiration_date, :review_landed_at, :reviewed_at, :reply_mail_sent_at, :reply_landed_at, :replied_at, :review_opened_at, :time_required, :price, :place, :description, :schedule_end, :place_memo, :refund_rate, :price_for_support, :price_for_both_guides, :space_option, :space_rental, :car_option, :car_rental, :gas, :highway, :parking, :guests_cost, :included_guests_cost, :msg, :reason
  
  form do |f|
    f.inputs do
      f.input :guest_id
      f.input :listing_id
      f.input :campaign_id
      f.input :schedule
      f.input :schedule_end
      f.input :num_of_people
      f.input :progress,
              :as => :select,
              :collection => Reservation.progresses.keys
      f.input :time_required
      f.input :price
      f.input :price_for_support
      f.input :price_for_both_guides
      f.input :space_option
      f.input :space_rental
      f.input :car_option
      f.input :car_rental
      f.input :gas
      f.input :highway
      f.input :parking
      f.input :guests_cost
      f.input :included_guests_cost
      f.input :place
      f.input :description
      f.input :place_memo
      f.input :refund_rate,
              :as => :select,
              :collection => [0, 50, 100]
      f.input :msg
      f.input :reason
      f.input :review_mail_sent_at
      f.input :review_expiration_date
      f.input :review_landed_at
      f.input :reviewed_at
      f.input :reply_mail_sent_at
      f.input :reply_landed_at
      f.input :replied_at
      f.input :review_opened_at
    end
    f.actions
  end
end
