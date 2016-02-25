class ReservationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.send_new_message_notification.subject
  #
  def send_new_reservation_notification(reservation)
    from_user = User.find(reservation.guest_id)
    @from_user_name  = "#{from_user.profile.first_name} #{from_user.profile.last_name}"
    to_user = User.find(reservation.host_id)
    @to_user_name = "#{to_user.profile.first_name} #{to_user.profile.last_name}"
    mail(
      to:      to_user.email,
      subject: I18n.t('mailer.new_reservation.subject.arrived', name: @from_user_name)
    ) do |format|
      format.text
    end
  end

  def send_new_reservation_notification_to_admin(reservation)
    @reservation = reservation
    @listing = reservation.listing
    @from_user = User.find(reservation.guest_id)
    @from_user_name  = "#{@from_user.profile.first_name} #{@from_user.profile.last_name}"
    @to_user = User.find(reservation.host_id)
    @to_user_name = "#{@to_user.profile.first_name} #{@to_user.profile.last_name}"
    mail(
      to:      ENV["OWNER_MAIL_ADDRESS"],
      subject: Settings.mailer.new_reservation_to_admin.subject.arrived
    ) do |format|
      format.text
    end
  end

  def send_new_guide_detail_notification(reservation)
    from_user = User.find(reservation.host_id)
    @from_user_name  = "#{from_user.profile.first_name} #{from_user.profile.last_name}"
    to_user = User.find(reservation.guest_id)
    @to_user_name = "#{to_user.profile.first_name} #{to_user.profile.last_name}"
    mail(
      to:      to_user.email,
      subject: Settings.mailer.new_guide_detail.subject.arrived
    ) do |format|
      format.text
    end
  end

  def send_update_reservation_notification(reservation, from_user_id)
    if from_user_id == reservation.guest_id
      to_user_id = reservation.host_id
      @dest = "host"
    elsif from_user_id == reservation.host_id
      to_user_id = reservation.guest_id
      @dest = "guest"
    end

    from_user = User.find(from_user_id)
    @from_user_name  = "#{from_user.profile.first_name} #{from_user.profile.last_name}"
    to_user = User.find(to_user_id)
    @to_user_name = "#{to_user.profile.first_name} #{to_user.profile.last_name}"

    @progress = reservation.string_of_progress_english

    mail(
      to:      to_user.email,
      subject: reservation.subject_of_update_mail
    ) do |format|
      format.text
    end
  end

  def send_week_before_notification(reservation, to_user_id)
    @reservation = reservation
    @listing = reservation.listing
    to_user = User.find(to_user_id)
    @to_user_name = "#{to_user.profile.first_name} #{to_user.profile.last_name}"
    @to_user_id_is_host = to_user_id == reservation.host_id
    another_user_id = @to_user_id_is_host ? reservation.guest_id : reservation.host_id
    another_user = User.find(another_user_id)
    @another_user_name = "#{another_user.profile.first_name} #{another_user.profile.last_name}"
    mail(
      to:      to_user.email,
      subject: I18n.t('mailer.week_before_notification.subject', name: @another_user_name)
    ) do |format|
      format.text
    end
  end

  def send_day_before_notification(reservation, to_user_id)
    @reservation = reservation
    @listing = reservation.listing
    to_user = User.find(to_user_id)
    @to_user_name = "#{to_user.profile.first_name} #{to_user.profile.last_name}"
    @to_user_id_is_host = to_user_id == reservation.host_id
    another_user_id = @to_user_id_is_host ? reservation.guest_id : reservation.host_id
    another_user = User.find(another_user_id)
    @another_user_name = "#{another_user.profile.first_name} #{another_user.profile.last_name}"
    subject = @to_user_id_is_host ? I18n.t('mailer.day_before_notification.subject.to_host', name: @another_user_name) : I18n.t('mailer.day_before_notification.subject.to_guest', name: @another_user_name)
    mail(
      to:      to_user.email,
      subject: subject
    ) do |format|
      format.text
    end
  end

  def send_cancel_mail_to_owner(reservation)
    @host = User.find(reservation.host_id)
    @guest = User.find(reservation.guest_id)
    @reservation = reservation
    @listing_detail = ListingDetail.where(listing_id: @reservation.listing.id).first
    @payment = reservation.try('payment')
    if @reservation.guide?
      @refund_from = @host
      @refund_to = @guest
      subject = Settings.mailer.send_cancel_from_guide_mail_to_owner.subject
    else
      @refund_from = @guest
      @refund_to = @host
      subject = Settings.mailer.send_cancel_from_guest_mail_to_owner.subject
    end
    mail(
      to:      ENV["OWNER_MAIL_ADDRESS"],
      subject: subject
    ) do |format|
      format.text
    end
  end

  def send_accepted_mail_to_owner(reservation)
    @host = User.find(reservation.host_id)
    @guest = User.find(reservation.guest_id)
    @reservation = reservation
    @listing_detail = ListingDetail.where(listing_id: @reservation.listing.id).first
    @payment = reservation.try('payment')

    mail(
      to:      ENV["OWNER_MAIL_TOUR_BOOKED_ADDRESS"],
      subject: Settings.mailer.send_accepted_mail_to_owner.subject
    ) do |format|
      format.text
    end
  end

  def send_requested_mail_to_owner(reservation)
    @host = User.find(reservation.host_id)
    @guest = User.find(reservation.guest_id)
    @reservation = reservation
    @listing_detail = ListingDetail.where(listing_id: @reservation.listing.id).first
    @payment = reservation.try('payment')

    mail(
      to:      ENV["OWNER_MAIL_TOUR_BOOKED_ADDRESS"],
      subject: Settings.mailer.send_requested_mail_to_owner.subject
    ) do |format|
      format.text
    end
  end
end
