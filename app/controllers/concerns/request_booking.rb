module RequestBooking
  
  def self.request_booking(reservation_params)
    para = reservation_params
    listing = Listing.find_by_id(reservation_params['listing_id'].to_i)
    para['host_id'] = listing.user_id
    para['progress'] = 'under_construction'
    para['schedule_date'] = Date.strptime(para['schedule_date'], '%m/%d/%Y').to_s
    para['schedule_end'] = para['schedule_date']
    para['schedule_hour'] = 00
    para['schedule_minute'] = 00
    para['price'] = listing.listing_detail.price
    para['price_for_support'] = listing.listing_detail.price_for_support
    para['price_for_both_guides'] = listing.listing_detail.price_for_both_guides
    para['car_option'] = listing.listing_detail.car_option
    para['bicycle_option'] = listing.listing_detail.bicycle_option
    para['other_option'] = listing.listing_detail.other_option
    para['guests_cost'] = listing.listing_detail.guests_cost
    para['included_guests_cost'] = listing.listing_detail.included_guests_cost
    para['time_required'] = listing.listing_detail.time_required
    para['place_memo'] = listing.listing_detail.place_memo
    listing.listing_detail.car_options.each do |option|
      para[option] = listing.listing_detail[option]
    end
    listing.listing_detail.bicycle_options.each do |option|
      para[option] = listing.listing_detail[option]
    end
    listing.listing_detail.other_options.each do |option|
      para[option] = listing.listing_detail[option]
    end

    reservation_before = Reservation.latest_reservation(reservation_params['guest_id'], reservation_params['host_id'])
    if reservation_before and reservation_before.canceled?
      @reservation = reservation_before
      result = @reservation.update(para)
    else
      @reservation = Reservation.new(para)
      result = @reservation.save
    end

    if result
      Ngevent.set_date(@reservation)
      ReservationMailer.send_new_reservation_notification(@reservation).deliver_now!
      ReservationMailer.send_new_reservation_notification_to_admin(@reservation).deliver_now!
      message = Message.send_request_message(@reservation)
    end
    message
  end
  
end