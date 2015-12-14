ActiveAdmin.register Reservation do
  index do
    column :id
    column :schedule
    column :schedule_end
    column :num_of_people
    column :msg
    column :progress
    column :reason
    column :review_mail_sent_at
    column :review_expiration_date
    column :review_landed_at
    column :reviewed_at
    column :reply_mail_sent_at
    column :reply_landed_at
    column :replied_at
    column :review_opened_at
    column :time_required
    column :price
    column :option_price
    column :place
    column :description
    column :option_price_per_person
    column :place_memo
    column :created_at
    column :updated_at
    actions
  end
end
