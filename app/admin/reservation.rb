ActiveAdmin.register Reservation do
  permit_params :guest_id, :listing_id, :campaign_id, :schedule, :num_of_people, :progress, :review_mail_sent_at, :review_expiration_date, :review_landed_at, :reviewed_at, :reply_mail_sent_at, :reply_landed_at, :replied_at, :review_opened_at, :time_required, :price, :place, :description, :schedule_end, :place_memo, :refund_rate, :price_for_support, :price_for_both_guides, :space_option, :space_rental, :car_option, :car_rental, :gas, :highway, :parking, :guests_cost, :included_guests_cost, :msg, :reason
  
  preserve_default_filters!
  remove_filter :user
  filter :host_id, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}
  filter :guest_id, :as => :select, :collection => User.all.map{|u| ["#{u.profile.last_name} #{u.profile.first_name}", u.id]}

  index do
    column :id do |reservation|
      link_to reservation.id, admin_reservation_path(reservation)
    end
    column :host_id do |reservation|
      reservation.host_profile_id
    end
    column :guest_id do |reservation|
      reservation.guest_profile_id
    end
    column :pair_guide_id do |reservation|
      reservation.pair_guide_profile_id
    end
    column :listing_id do |reservation|
      if reservation.listing_id.present?
        link_to Listing.find(reservation.listing_id).title, admin_listing_path(reservation.listing_id)
      end
    end
    column :schedule
    column :schedule_end
    column :num_of_people
    column :progress
    column :time_required
    column :price
    column :price_for_support
    column :price_for_both_guides
    column :place
    column :place_memo
    column :space_option
    column :space_rental
    column :car_option
    column :car_rental
    column :gas
    column :highway
    column :parking
    column :guests_cost
    column :included_guests_cost
    column :description
    column :msg
    column :reason
    column :refund_rate
    column :review_mail_sent_at
    column :review_expiration_date
    column :review_landed_at
    column :reviewed_at
    column :reply_mail_sent_at
    column :reply_landed_at
    column :replied_at
    column :review_opened_at
    column 'Paypal決済トランID' do |reservation|
      payment = Payment.where(reservation_id: reservation.id).first
      payment.try('transaction_id') || '' if payment.present?
    end
    column :created_at
    column :updated_at
    actions
  end
  
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
  
  show do
    attributes_table do
      Reservation.column_names.each do |col|
        if col == 'host_id'
          row :host_id do |reservation|
            reservation.host_profile_id
          end
        elsif col == 'guest_id'
          row :guest_id do |reservation|
            reservation.guest_profile_id
          end
        elsif col == 'pair_guide_id'
          row :pair_guide_id do |reservation|
            reservation.pair_guide_profile_id
          end
        else
          row col
        end
      end
      row "Paypal決済トランID" do |reservation|
        payment = Payment.where(reservation_id: reservation.id).first
        payment.try('transaction_id') || '' if payment.present?
      end
    end
    active_admin_comments
  end
end
