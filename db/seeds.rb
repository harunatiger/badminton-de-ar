require 'csv'

i = 1
CSV.foreach('db/seeds_data/categories.csv') do |row|
  category = Category.where(id: i).first
  if category
    category.update(name: row[0])
  else
    Category.create(name: row[0])
  end
  i += 1
end

i = 1
CSV.foreach('db/seeds_data/languages.csv') do |row|
  language = Language.where(id: i).first
  if language
    language.update(name: row[0])
  else
    Language.create(name: row[0])
  end
  i += 1
end
=begin
i = 1
CSV.foreach('db/seeds_data/campaign.csv') do |row|
  campaign = Campaign.where(id: i).first
  if campaign
    campaign.update(code: row[0], discount: row[1], type: row[2])
  else
    Campaign.create(code: row[0], discount: row[1], type: row[2])
  end
  i += 1
end

i = 31
CSV.foreach('db/seeds_data/reservations.csv') do |row|
  reservation = Reservation.where(id: i).first
  if reservation
    reservation.update(host_id: row[0], :guest_id => row[1],
      :listing_id => row[2], schedule: row[3],
      :num_of_people => row[4], :msg => row[5],
      :progress => row[6], :reason => row[7],
      :review_mail_sent_at => row[8], :review_expiration_date => row[9],
      :review_landed_at => row[10], :reviewed_at => row[11],
      :reply_mail_sent_at => row[12], :reply_landed_at => row[13],
      :replied_at => row[14], :review_opened_at => row[15],
      :time_required => row[16], price: row[17],
      :option_price => row[18], :place => row[19],
      :description => row[20], :schedule_end => row[21],
      :option_price_per_person => row[22], :place_memo => row[23],
      :campaign_id => row[24], :price_other => row[25],
      :refund_rate => row[26], :created_at => row[27], :updated_at => row[28]
      )
  else
    Reservation.create(host_id: row[0], :guest_id => row[1],
      :listing_id => row[2], schedule: row[3],
      :num_of_people => row[4], :msg => row[5],
      :progress => row[6], :reason => row[7],
      :review_mail_sent_at => row[8], :review_expiration_date => row[9],
      :review_landed_at => row[10], :reviewed_at => row[11],
      :reply_mail_sent_at => row[12], :reply_landed_at => row[13],
      :replied_at => row[14], :review_opened_at => row[15],
      :time_required => row[16], price: row[17],
      :option_price => row[18], :place => row[19],
      :description => row[20], :schedule_end => row[21],
      :option_price_per_person => row[22], :place_memo => row[23],
      :campaign_id => row[24], :price_other => row[25],
      :refund_rate => row[26], :created_at => row[27], :updated_at => row[28]
      )
  end
  i += 1
end

i = 11
CSV.foreach('db/seeds_data/payments.csv') do |row|
  payment = Payment.where(id: i).first
  if payment
    payment.update(reservation_id: row[0], :token => row[1],
      :payer_id => row[2], payers_status: row[3],
      :transaction_id => row[4], :payment_status => row[5],
      :amount => row[6], :currency_code => row[7],
      :email => row[8], :first_name => row[9],
      :last_name => row[10], :country_code => row[11],
      :transaction_date => row[12], :refund_date => row[13],
      :created_at => row[14], :updated_at => row[15]
    )
  else
    Payment.create(reservation_id: row[0], :token => row[1],
      :payer_id => row[2], payers_status: row[3],
      :transaction_id => row[4], :payment_status => row[5],
      :amount => row[6], :currency_code => row[7],
      :email => row[8], :first_name => row[9],
      :last_name => row[10], :country_code => row[11],
      :transaction_date => row[12], :refund_date => row[13],
      :created_at => row[14], :updated_at => row[15]
    )
  end
  i += 1
end
=end
